@keybaseGui.controller 'ImportPrivateKeyController', ["$scope", "openPGP", ($scope, openPgp) ->
  $scope.import = ->
    privateKey = $scope.key
    key = openPgp.readPrivateKey(privateKey).keys[0]

    if key and key.isPrivate
      data = openPgp.storePrivateKey(privateKey)

  ]
