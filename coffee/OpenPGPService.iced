@keybaseGui.factory 'openPGP', [ () ->
  openPgp = require('openpgp')
  keyring = new openPgp.Keyring()

  inited = false

  {
    init: () ->
      unless inited?
        openPgp.init()
        inited = true

    readPublicKey: (keyString, cb) ->
      process.nextTick () ->
        cb openPgp.key.readArmored(keyString)

    readPrivateKey: (keyString, cb) ->
      process.nextTick () ->
        key = openPgp.key.readArmored(keyString)
        cb key

    storePrivateKey: (keyString, cb) ->
      process.nextTick() ->
        key = keyring.privateKeys.importKey keyString
        keyring.store()
        cb()

    getStoredPrivateKeys: (cb) ->
      process.nextTick () ->
        cb keyring.privateKeys.keys

    getStoredPrivateKeysSync: ->
      keyring.privateKeys.keys

    encryptMessage: (publicKey, plaintext, cb) ->
      process.nextTick () ->
        cb openPgp.encryptMessage [publicKey], plaintext

    decryptMessage: (privateKey, msg, cb) ->
      process.nextTick () ->
        cb openPgp.decryptMessage(privateKey, openPgp.message.readArmored(msg))
  }
]
