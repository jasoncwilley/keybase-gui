@keybaseGui.controller 'EncryptMessageController', ["$scope", "$rootScope",
"openPGP", "keybaseApi", '$modal',
($scope, $rootScope, openPgp, keybaseApi, $modal) ->
  $scope.sign = false

  $scope.encrypt = ->
    openPgp.init()

    plainText = $scope.plaintext

    primaryKeyString = $rootScope.selectedFriend.public_keys.primary.bundle
    await openPgp.readPublicKey(primaryKeyString, defer primaryKey)

    primaryKey = primaryKey.keys[0]

    privateKey = null

    if $scope.sign
      privateKey = $rootScope.data.selectedPrivateKey
      if not privateKey.isDecrypted
        modalInstance = $modal.open {
          templateUrl: 'passwordModalTemplate.html'
          controller: 'PasswordModalController'
        }
        await modalInstance.result.then defer password
        privateKey.decrypt(password)

    await openPgp.encryptMessage primaryKey, privateKey,
    plainText, defer encrypted

    $scope.$apply ->
      $scope.encrypted = encrypted
  ]
