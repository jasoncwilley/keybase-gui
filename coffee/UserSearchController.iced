@keybaseGui.controller 'UserSearchController', ['$scope', 'keybaseApi', ($scope, keybaseApi) ->
  $scope.lookup = ->
    await keybaseApi.lookup $scope.username, defer err, user
    $scope.user = user
]
