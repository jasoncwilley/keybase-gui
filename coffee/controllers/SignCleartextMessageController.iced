@keybaseGui.controller 'SignCleartextMessageController', ["$scope",
"$rootScope", "openPGP", '$modal',
($scope, $rootScope, openPgp, $modal) ->

  $scope.signMessage = () ->
    privateKey =  $rootScope.data.selectedPrivateKey
    if not privateKey.isDecrypted
      modalInstance = $modal.open {
        templateUrl: 'passwordModalTemplate.html'
        controller: 'PasswordModalController'
      }
      await modalInstance.result.then defer password
      privateKey.decrypt(password)
    message = ($scope.plaintext)
    await openPgp.signCleartextMessage privateKey, message, defer signed
    $scope.signed = signed
]
