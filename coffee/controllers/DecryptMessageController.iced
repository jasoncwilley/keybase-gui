@keybaseGui.controller 'DecryptMessageController', ["$scope", "openPGP",
'$modal', ($scope, openPgp, $modal) ->

  $scope.decryptMessage = ->
    privateKey = $scope.privateKey

    if not privateKey.isDecrypted
      modalInstance = $modal.open {
        templateUrl: 'passwordModalTemplate.html'
        controller: 'PasswordModalController'
      }
      await modalInstance.result.then defer password
      privateKey.decrypt(password)
    message = ($scope.encryptedMessage)
    await openPgp.decryptMessage privateKey, message, defer decrypted
    alert decrypted
]
