@keybaseGui.controller 'ImportPrivateKeyController', ["$scope", "openPGP", ($scope, openPgp) ->
  $scope.importKey = ->
    privateKey = $scope.key

    await openPgp.readPrivateKey privateKey, defer key

    key = key.keys[0]

    if key and key.isPrivate
      await openPgp.storePrivateKey(privateKey)

  ]
