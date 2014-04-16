@keybaseGui.controller 'VerifyCleartextMessageController', ["$scope", "openPGP", ($scope, openPgp) ->
  $scope.verifyMessage = () ->
    await openPgp.getSigningKeyIdsMessage $scope.signedMessage, defer keyIds
    await openPgp.getStoredPublicKeys defer storedPublicKeys

    foundKeys = []
    unresolvedKeyIds = []

    angular.forEach keyIds, (keyId, index2) ->
      keyFound = false
      angular.forEach storedPublicKeys, (publicKey, index) ->
        if publicKey.primaryKey.keyid.bytes == keyId.bytes
          foundKeys.push publicKey
          keyFound = true
      unless keyFound
        unresolvedKeyIds.push keyId

    $scope.signers = foundKeys
    console.log foundKeys
]
