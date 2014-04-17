@keybaseGui.directive 'privateKeySelect', ['openPGP', (openPgp) ->
  {
    restrict: 'E'
    scope: {
      selectedPrivateKey: '=ngModel'
    }
    template: "<select ng-model='selectedPrivateKey'
                ng-options='
                (privateKey.primaryKey.optimizedFingerprint) | uppercase
                for privateKey in privateKeys
              '></select>"
    link: ($scope, element, attributes) ->
      $scope.privateKeys = openPgp.getStoredPrivateKeysSync()

      for privateKey in $scope.privateKeys
        privateKey.primaryKey.optimizedFingerprint =
          privateKey.primaryKey.fingerprint.match(/.{1,4}/g).join(" ")

      unless $scope.selectedPrivateKey
        $scope.selectedPrivateKey = $scope.privateKeys[0]

  }
]
