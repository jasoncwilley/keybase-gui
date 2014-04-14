@keybaseGui.controller 'LoginController', ["$scope", "keybaseApi", ($scope, keybaseApi) ->
  $scope.login = ->
    await keybaseApi.login $scope.username, $scope.password, defer err, session, me
]
