@keybaseGui.controller 'ImportPrivateKeyModalController', ["$scope", "openPGP",
'$modalInstance', ($scope, openPgp, $modalInstance) ->

  $scope.importKey = ->
    privateKey = $scope.key

    await openPgp.readPrivateKey privateKey, defer key

    key = key.keys[0]

    if key and key.isPrivate
      await openPgp.storePrivateKey(privateKey)
      $scope.apply
      $modalInstance.close key
  $scope.cancel = ->
    $modalInstance.dismiss 'cancel'
  ]
