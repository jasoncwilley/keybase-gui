@keybaseGui.controller 'LoginController', ($scope) ->
  $scope.login = ->
    alert "Hello, " + $scope.username + "!"
