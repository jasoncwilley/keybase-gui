@keybaseGui.controller 'UserSearchController', ['$scope', '$rootScope',
'$timeout', 'keybaseApi', 'storage', 'openPGP',
($scope, $rootScope, $timeout, keybaseApi, storage, openPgp) ->

  storage.bind($rootScope, "friends", { defaultValue: [] })

  $scope.suggestions = []

  updateTimeout = null
  typedString = ""

  updateSuggestions = () ->
    await keybaseApi.autocomplete typedString, defer suggestions
    $scope.suggestions = suggestions

  $scope.queueUpdateSuggestions = (typed) ->
    updateTimeout.cancel if updateTimeout
    typedString = typed
    $timeout updateSuggestions, 250

  $scope.getSuggestions = (typed) ->
    keybaseApi.autocompletePromise(typed).then (res) ->
      if res.data.status.code != 0
        return []
        
      completions = res.data.completions
      completions.sort (a, b) ->
        b.totalScore - a.totalScore

      results = []

      for value in completions
        results.push value.components.username.val
      return results

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
