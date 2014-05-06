@keybaseGui.controller 'KeybaseGuiApplicationController', [ '$rootScope',
'$scope', 'openPGP', '$modal', 'keybaseGuiConfig',
'$http', '$interval', 'keybaseGuiUpdater',
($rootScope, $scope, openPgp, $modal, keybaseGuiConfig,
 $http, $interval, keybaseGuiUpdater) ->

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

  $scope.checkForUpdates = ->
    keybaseGuiUpdater.checkForUpdates()

  $scope.downloadAndUpdateNWPackage = ->
    console.log "Not yet implemented...."

  $rootScope.$on 'updater:binary-update-available', (event, args) ->
    $scope.addAlert(
      "There's a new binary version of Keybase-Gui! You can download it
      <a href='#{args.url}'>here</a>.",
      "info"
    )



  $scope.checkForUpdates()
  $interval($scope.checkForUpdates, 1000 * 60)
]
