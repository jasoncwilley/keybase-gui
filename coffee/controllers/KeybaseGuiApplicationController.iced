@keybaseGui.controller 'KeybaseGuiApplicationController', ['$rootScope',
'openPGP', ($rootScope, openPgp) ->
  $rootScope.data = {}
  $rootScope.data.selectedPrivateKey = openPgp.getStoredPrivateKeysSync()[0]
]
