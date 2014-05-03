@keybaseGui.controller 'KeybaseGuiApplicationController', [ '$rootScope',
'$scope', 'openPGP', '$modal', 'keybaseGuiConfig', '$http',
($rootScope, $scope, openPgp, $modal, keybaseGuiConfig, $http) ->
  $rootScope.data = {}
  $rootScope.data.selectedPrivateKey = openPgp.getStoredPrivateKeysSync()[0]

  $scope.alerts = []

  $scope.openImportStringModal = () ->
    $modalInstance = $modal.open {
      templateUrl: "importPrivateKeyModalTemplate.html"
      controller: "ImportPrivateKeyModalController"
    }

    await $modalInstance.result.then defer key

  $scope.openLoginModal = () ->
    $modalInstance = $modal.open {
      templateUrl: "loginModalTemplate.html"
      controller: "LoginModalController"
    }

    await $modalInstance.result.then defer key

  $scope.closeWindow = ->
    gui = require('nw.gui')
    window = gui.Window.get()
    window.close()

  $scope.minimizeWindow = ->
    gui = require('nw.gui')
    window = gui.Window.get()
    window.minimize()

  $scope.maximizeWindow = ->
    gui = require('nw.gui')
    window = gui.Window.get()
    window.maximize()

  $scope.addAlert = (msg, type) ->
    $scope.alerts.push({
      msg: msg
      type: type
    })

  $scope.closeAlert = (index) ->
    $scope.alerts.splice(index, 1)


  getRemoteDownloadLink = (version) ->
    os = require('os')

    server = keybaseGuiConfig.updateServer
    name ="keybase-gui"

    platform = os.platform()
    plat = ""

    if platform == 'linux'
      plat = "linux"
      if os.arch() == "x64"
        plat += "64"
      else
        plat += "32"
    else if platform == 'win32'
      plat = "win"
    else if platform == "darwin"
      plat = "mac"

    "#{server}#{name}.#{plat}.#{version}.zip"

  await $http.get(keybaseGuiConfig.updateServer + 'version.txt')
  .success defer data, status

  remoteVersion = parseInt data
  localVersion = keybaseGuiConfig.version

  if remoteVersion > localVersion
    downloadLink = getRemoteDownloadLink remoteVersion
    $scope.addAlert(
      "There's a new version of Keybase-Gui! You can download it
      <a href='#{downloadLink}'>here</a>.",
      "info"
    )


]
