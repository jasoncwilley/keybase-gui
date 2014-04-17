@keybaseGui.controller 'SignCleartextMessageController', ["$scope", "openPGP",
($scope, openPgp) ->

  $scope.signMessage = () ->
    privateKey = $scope.privateKey
    if not privateKey.isDecrypted
      privateKey.decrypt($scope.password)
    message = ($scope.plaintext)
    await openPgp.signCleartextMessage privateKey, message, defer signed
    $scope.signed = signed
]
