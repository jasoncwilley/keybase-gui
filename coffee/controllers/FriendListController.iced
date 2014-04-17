@keybaseGui.controller 'FriendListController', ["$scope", '$rootScope',
'storage', ($scope, $rootScope, storage) ->
  storage.bind $rootScope, 'friends', { defaultValue: [] }

  $rootScope.selectedFriend = null

  $scope.selectUser = (user) ->
    $rootScope.selectedFriend = user
]
