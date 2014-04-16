@keybaseGui.controller 'UserSearchController', ['$scope', '$rootScope',
'keybaseApi', 'storage', 'openPGP', ($scope, $rootScope, keybaseApi, storage, openPgp) ->
  storage.bind($rootScope, "friends", { defaultValue: [] })

  $scope.suggestions = []

  $scope.updateSuggestions = (typed) ->
    await keybaseApi.autocomplete typed, defer suggestions
    $scope.suggestions = suggestions
    console.log suggestions

  $scope.lookup = ->
    await keybaseApi.lookup $scope.username, defer err, user

    found = false

    angular.forEach $scope.friends, (value, key) ->
      found = true if value.id == user.id

    unless found
      $rootScope.friends.push user

    $scope.user = user
    unless found
      await openPgp.storePublicKey(user.public_keys.primary.bundle)
]
