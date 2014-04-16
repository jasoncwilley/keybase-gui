@keybaseGui.controller 'UserSearchController', ['$scope', '$rootScope', 'keybaseApi', 'storage', ($scope, $rootScope, keybaseApi, storage) ->
  storage.bind($rootScope, "friends", { defaultValue: [] })

  $scope.lookup = ->
    await keybaseApi.lookup $scope.username, defer err, user

    $scope.friends.push user
    $scope.user = user
]
