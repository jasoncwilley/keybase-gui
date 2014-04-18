@keybaseGui.controller 'DecryptMessageController', ["$scope", "$rootScope",
"openPGP", '$modal', "keybaseApi",
($scope, $rootScope, openPgp, $modal, keybaseApi) ->

  $scope.modes = ["enc", "plaintext"]
  $scope.mode = $scope.modes[0]
  
  $scope.data = {}
  $scope.data.encryptedMessage = ''
  $scope.data.decryptedMessage = ''
  $scope.data.signers = []
  $scope.data.verify = false

  $scope.decryptMessage = ->
    privateKey = $rootScope.data.selectedPrivateKey

    if not privateKey.isDecrypted
      modalInstance = $modal.open {
        templateUrl: 'passwordModalTemplate.html'
        controller: 'PasswordModalController'
      }
      await modalInstance.result.then defer password
      privateKey.decrypt(password)

    message = $scope.data.encryptedMessage
    await openPgp.decryptMessage privateKey, message, defer decrypted, armored
    $scope.data.decryptedMessage = decrypted
    armored = armored.decrypt privateKey
    $scope.mode = $scope.modes[1]
    
    if $scope.data.verify
      await openPgp.getSigningKeyIdsArmoredMessage armored, defer keyIds
      $scope.data.signers = []

      await openPgp.resolveKeyIdsFromStorage keyIds,
      defer storeResolvedKeys, storeUnresolvedKeys

      $scope.data.signers = $scope.data.signers.concat storeResolvedKeys

      await keybaseApi.resolveKeyIds storeUnresolvedKeys,
      defer kbResolvedKeys, kbUnresolvedKeys

      $scope.data.signers = $scope.data.signers.concat kbResolvedKeys
      
      $scope.$apply()

      #TODO: fetch missing keyIds from MIT server
    
  $scope.back = ->
    $scope.mode = $scope.modes[0]
]
