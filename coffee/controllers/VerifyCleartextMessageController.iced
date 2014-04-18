@keybaseGui.controller 'VerifyCleartextMessageController', ["$scope", "openPGP",
"keybaseApi", ($scope, openPgp, keybaseApi) ->
  
  $scope.modes = ["signed", "verified"]
  $scope.mode = $scope.modes[0]
  
  $scope.data = {}
  $scope.data.signedMessage = ''
  $scope.data.signers = []
  $scope.data.verifiedMessage = ""
  
  $scope.verifyMessage = () ->
    await openPgp.getSigningKeyIdsMessage $scope.data.signedMessage,
    defer keyIds
    
    await openPgp.getStoredPublicKeys defer storedPublicKeys

    $scope.data.signers = []

    await openPgp.resolveKeyIdsFromStorage keyIds,
    defer storeResolvedKeys, storeUnresolvedKeys

    $scope.data.signers = $scope.data.signers.concat storeResolvedKeys

    await keybaseApi.resolveKeyIds storeUnresolvedKeys,
    defer kbResolvedKeys, kbUnresolvedKeys

    $scope.data.signers = $scope.data.signers.concat kbResolvedKeys
    await openPgp.getCleartextMessageText $scope.data.signedMessage, defer text

    $scope.data.verifiedMessage = text
    $scope.mode = $scope.modes[1]
    
    $scope.$apply()
    # TODO: Search on SKS Keyservers (MIT I'd say)
    
  $scope.back = ->
    $scope.mode = $scope.modes[1]
]
