@keybaseGui.controller 'VerifyCleartextMessageController', ["$scope", "openPGP", "keybaseApi", ($scope, openPgp, keybaseApi) ->
  $scope.verifyMessage = () ->
    await openPgp.getSigningKeyIdsMessage $scope.signedMessage, defer keyIds
    await openPgp.getStoredPublicKeys defer storedPublicKeys

    $scope.signers = []

    await openPgp.resolveKeyIdsFromStorage keyIds, defer storeResolvedKeys, storeUnresolvedKeys
    $scope.signers = $scope.signers.concat storeResolvedKeys

    await keybaseApi.resolveKeyIds storeUnresolvedKeys, defer kbResolvedKeys, kbUnresolvedKeys

    $scope.signers = $scope.signers.concat kbResolvedKeys
    $scope.$apply()
    # TODO: Search on SKS Keyservers (MIT I'd say)
]
