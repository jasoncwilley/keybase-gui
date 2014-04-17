@keybaseGui.controller 'DecryptMessageController', ["$scope", "$rootScope",
 "openPGP", '$modal', "keybaseApi",
 ($scope, $rootScope, openPgp, $modal, keybaseApi) ->

  $scope.decryptMessage = ->
    privateKey = $rootScope.data.selectedPrivateKey

    if not privateKey.isDecrypted
      modalInstance = $modal.open {
        templateUrl: 'passwordModalTemplate.html'
        controller: 'PasswordModalController'
      }
      await modalInstance.result.then defer password
      privateKey.decrypt(password)

    message = $scope.encryptedMessage
    await openPgp.decryptMessage privateKey, message, defer decrypted, armored
    alert decrypted
    armored = armored.decrypt privateKey
    if $scope.verify
      await openPgp.getSigningKeyIdsArmoredMessage armored, defer keyIds
      $scope.signers = []

      await openPgp.resolveKeyIdsFromStorage keyIds,
      defer storeResolvedKeys, storeUnresolvedKeys

      $scope.signers = $scope.signers.concat storeResolvedKeys

      await keybaseApi.resolveKeyIds storeUnresolvedKeys,
      defer kbResolvedKeys, kbUnresolvedKeys

      $scope.signers = $scope.signers.concat kbResolvedKeys
      $scope.$apply()

    #TODO: fetch missing keyIds from MIT server
]
