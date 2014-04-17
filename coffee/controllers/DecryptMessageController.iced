@keybaseGui.controller 'DecryptMessageController', ["$scope", "openPGP",
($scope, openPgp) ->

  $scope.decryptMessage = ->
    privateKey = $scope.privateKey
    if not privateKey.isDecrypted
      privateKey.decrypt($scope.password)
    message = ($scope.encryptedMessage)
    await openPgp.decryptMessage privateKey, message, defer decrypted
    alert decrypted
]
