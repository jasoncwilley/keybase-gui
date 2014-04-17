@keybaseGui.controller 'VerifyCleartextMessageController', ["$scope", "openPGP", "keybaseApi", ($scope, openPgp, keybaseApi) ->
  $scope.verifyMessage = () ->
    await openPgp.getSigningKeyIdsMessage $scope.signedMessage, defer keyIds
    await openPgp.getStoredPublicKeys defer storedPublicKeys

    $scope.signers = []
    unresolvedKeyIds = []

    angular.forEach keyIds, (keyId, index2) ->
      keyFound = false
      angular.forEach storedPublicKeys, (publicKey, index) ->
        if publicKey.primaryKey.keyid.bytes == keyId.bytes
          $scope.signers.push publicKey
          keyFound = true

      unless keyFound
        unresolvedKeyIds.push keyId

    stillNotResolvedKeys = []
    angular.forEach unresolvedKeyIds, (keyId, index) ->
      await keybaseApi.lookupKey openPgp.hexstrdump(keyId.bytes), defer key

      await openPgp.readPublicKey key.bundle, defer foundKey
      if foundKey
        foundKey = foundKey.keys[0]
        $scope.signers.push foundKey
        $scope.apply
      else
        stillNotResolvedKeys.push keyId

    # TODO: Search on SKS Keyservers (MIT I'd say)
]
