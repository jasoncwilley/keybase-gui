@keybaseGui.controller 'EncryptMessageController', ["$scope", "openPGP", "keybaseApi", ($scope, openPgp, keybaseApi) ->
  $scope.encrypt = ->
    openPgp.init()

    receiverName = $scope.receiver
    plainText = $scope.plaintext

    await keybaseApi.lookup receiverName, defer err, them

    primaryKeyString = them.public_keys.primary.bundle
    await openPgp.readPublicKey(primaryKeyString, defer primaryKey)

    primaryKey = primaryKey.keys[0]

    await openPgp.encryptMessage primaryKey, plainText, defer encrypted
    $scope.$apply ->
      $scope.encrypted = encrypted
  ]
