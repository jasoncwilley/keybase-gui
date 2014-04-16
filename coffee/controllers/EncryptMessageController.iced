@keybaseGui.controller 'EncryptMessageController', ["$scope", "$rootScope", "openPGP", "keybaseApi", ($scope, $rootScope, openPgp, keybaseApi) ->
  $scope.sign = false
  $scope.privateKeys = openPgp.getStoredPrivateKeysSync()
  $scope.privateKey = $scope.privateKeys[0] unless $scope.privateKeys.length == 0

  $scope.encrypt = ->
    openPgp.init()

    plainText = $scope.plaintext

    primaryKeyString = $rootScope.selectedFriend.public_keys.primary.bundle
    await openPgp.readPublicKey(primaryKeyString, defer primaryKey)

    primaryKey = primaryKey.keys[0]

    privateKey = null
    
    if $scope.sign
      privateKey = $scope.privateKey
      if not privateKey.isDecrypted
        privateKey.decrypt($scope.password)

    await openPgp.encryptMessage primaryKey, privateKey, plainText, defer encrypted
    $scope.$apply ->
      $scope.encrypted = encrypted
  ]
