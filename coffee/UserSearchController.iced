@keybaseGui.controller 'UserSearchController', ['$scope', '$rootScope',
'keybaseApi', 'storage', 'openPGP', ($scope, $rootScope, keybaseApi, storage, openPgp) ->
  storage.bind($rootScope, "friends", { defaultValue: [] })

  $scope.lookup = ->
    await keybaseApi.lookup $scope.username, defer err, user

    $scope.friends.push user
    $scope.user = user

    await openPgp.storePublicKey(user.public_keys.primary.bundle)
]
