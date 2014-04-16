@keybaseGui.controller 'SignCleartextMessageController', ["$scope", "openPGP", ($scope, openPgp) ->
  $scope.privateKeys = openPgp.getStoredPrivateKeysSync()
  $scope.privateKey = $scope.privateKeys[0] unless $scope.privateKeys.length == 0

  $scope.signMessage = () ->
    privateKey = $scope.privateKey
    if not privateKey.isDecrypted
      privateKey.decrypt($scope.password)
    message = ($scope.plaintext)
    await openPgp.signCleartextMessage privateKey, message, defer signed
    $scope.signed = signed
]
