@keybaseGui.controller 'PasswordModalController', ["$scope", "$modalInstance",
($scope, $modalInstance) ->
  $scope.user = {password: ''}

  $scope.ok = () ->
    $modalInstance.close($scope.user.password)

  $scope.cancel = () ->
    $modalInstance.dismiss 'cancel'
]
