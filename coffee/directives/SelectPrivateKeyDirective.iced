@keybaseGui.directive 'privateKeySelect', ['openPGP', (openPgp) ->
  {
    restrict: 'E'
    scope: {
      selectedPrivateKey: '=ngModel'
    }
    template: "<select ng-model='selectedPrivateKey' ng-options='privateKey.primaryKey.fingerprint for privateKey in privateKeys'></select>"
    link: ($scope, element, attributes) ->
      $scope.privateKeys = openPgp.getStoredPrivateKeysSync()
      $scope.selectedPrivateKey = $scope.privateKeys[0] unless $scope.selectedPrivateKey 

  }
]
