@keybaseGui.controller 'SignCleartextMessageController', ["$scope",
"$rootScope", "openPGP", '$modal',
($scope, $rootScope, openPgp, $modal) ->
  
  $scope.modes = ["plaintext", "signed"]
  $scope.mode = $scope.modes[0]
  
  $scope.data = {}
  $scope.data.plaintext = ""
  $scope.data.signed = ""
  
  $scope.signMessage = () ->
    privateKey =  $rootScope.data.selectedPrivateKey
    if not privateKey.isDecrypted
      modalInstance = $modal.open {
        templateUrl: 'passwordModalTemplate.html'
        controller: 'PasswordModalController'
      }
      await modalInstance.result.then defer password
      privateKey.decrypt(password)
    message = ($scope.data.plaintext)
    await openPgp.signCleartextMessage privateKey, message, defer signed
    $scope.data.signed = signed
    $scope.mode = $scope.modes[1]
    
  $scope.back = ->
    $scope.mode = $scope.modes[0]
]
