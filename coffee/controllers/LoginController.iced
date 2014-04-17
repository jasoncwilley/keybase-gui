@keybaseGui.controller 'LoginController', ["$scope", "$http", "keybaseApi",
($scope, $http, keybaseApi) ->

  $scope.login = ->
    await keybaseApi.login $scope.username, $scope.password,
    defer err, session, me

    unless err?
      $http.defaults.headers.common.Cookie =
        "session=#{session}" # Save the current Session-Cookie
]
