@keybaseGui.controller 'LoginModalController', ["$scope", "$http",
"keybaseApi", '$modalInstance', ($scope, $http, keybaseApi, $modalInstance) ->

  $scope.login = ->
    await keybaseApi.login $scope.username, $scope.password,
    defer err, session, me

    unless err?
      $http.defaults.headers.common.Cookie =
        "session=#{session}" # Save the current Session-Cookie
      # TODO: Import the private key.
     $modalInstance.close me

  $scope.cancel = ->
    $modalInstance.dismiss 'cancel'
]
