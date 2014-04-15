@keybaseGui.factory 'openPGP', [ () ->
  openPgp = require('openpgp')
  keyring = new openPgp.Keyring()
  inited = false
  {
    init: () ->
      unless inited?
        openPgp.init()
        inited = true

    readPublicKey: (keyString) ->
      openPgp.key.readArmored(keyString)

    readPrivateKey: (keyString) ->
      openPgp.key.readArmored(keyString)

    storePrivateKey: (keyString) ->
      key = keyring.privateKeys.importKey keyString
      keyring.store()

    getStoredPrivateKeys: () ->
      keyring.privateKeys.keys

    encryptMessage: (publicKey, plaintext) ->
      openPgp.encryptMessage [publicKey], plaintext
  }
]
