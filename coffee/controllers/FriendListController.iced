@keybaseGui.controller 'FriendListController', ["$scope", '$rootScope',
'storage', ($scope, $rootScope, storage) ->
  storage.bind $rootScope, 'friends', { defaultValue: [] }

  $rootScope.selectedFriend = $rootScope.friends[0]

  $scope.selectUser = (user) ->
    $rootScope.selectedFriend = user
]
