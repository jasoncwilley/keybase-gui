@keybaseGui.controller 'EncryptMessageController', ["$scope", "$rootScope", "openPGP", "keybaseApi", ($scope, $rootScope, openPgp, keybaseApi) ->
  $scope.encrypt = ->
    openPgp.init()

    plainText = $scope.plaintext

    primaryKeyString = $rootScope.selectedFriend.public_keys.primary.bundle
    await openPgp.readPublicKey(primaryKeyString, defer primaryKey)

    primaryKey = primaryKey.keys[0]

    await openPgp.encryptMessage primaryKey, plainText, defer encrypted
    $scope.$apply ->
      $scope.encrypted = encrypted
  ]
