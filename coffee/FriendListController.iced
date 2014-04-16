@keybaseGui.controller 'FriendListController', ["$scope", '$rootScope', 'storage', ($scope, $rootScope, storage) ->
  storage.bind $rootScope, 'friends', { defaultValue: [] }
]
