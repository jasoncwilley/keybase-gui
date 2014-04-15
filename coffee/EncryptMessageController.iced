@keybaseGui.controller 'EncryptMessageController', ["$scope", "openPGP", "keybaseApi", ($scope, openPgp, keybaseApi) ->
  $scope.encrypt = ->
    openPgp.init()

    receiverName = $scope.receiver
    plainText = $scope.plaintext

    await keybaseApi.lookup receiverName, defer err, them

    primaryKeyString = them.public_keys.primary.bundle
    primaryKey = openPgp.readPublicKey(primaryKeyString).keys[0]

    encrypted = openPgp.encryptMessage primaryKey, plainText
    $scope.encrypted = encrypted
  ]
