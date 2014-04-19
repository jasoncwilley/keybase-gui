@keybaseGui.controller 'KeybaseGuiApplicationController', ['$rootScope',
'$scope', 'openPGP', '$modal', ($rootScope, $scope, openPgp, $modal) ->
  $rootScope.data = {}
  $rootScope.data.selectedPrivateKey = openPgp.getStoredPrivateKeysSync()[0]

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
  

]
