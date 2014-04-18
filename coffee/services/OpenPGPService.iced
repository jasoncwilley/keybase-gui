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
      process.nextTick () ->
        key = keyring.privateKeys.importKey keyString
        keyring.store()
        cb() if cb

    storePublicKey: (keyString, cb) ->
      process.nextTick () ->
        key = keyring.publicKeys.importKey keyString
        keyring.store()
        cb() if cb

    getStoredPrivateKeys: (cb) ->
      process.nextTick () ->
        cb keyring.privateKeys.keys

    getStoredPublicKeys: (cb) ->
      process.nextTick () ->
        cb keyring.publicKeys.keys

    getPublicKeysForKeyId: (keyId, deep, cb) ->
      process.nextTick() ->
        keys = keyring.publicKeys.getForId(keyId, deep)
        cb keys

    getPublicKeysForEmail: (email, cb) ->
      process.nextTick() ->
        keys = keystore.publicKeys.getForAddress(email)
        cb keys

    getStoredPrivateKeysSync: ->
      keyring.privateKeys.keys

    encryptMessage: (publicKey, privateKey, plaintext, cb) ->
      process.nextTick () ->
        enc = null
        if privateKey
          enc = openPgp.signAndEncryptMessage([publicKey],
                  privateKey, plaintext)
        else
          enc = openPgp.encryptMessage [publicKey], plaintext
        cb enc

    decryptMessage: (privateKey, msg, cb) ->
      process.nextTick () ->
        armored = openPgp.message.readArmored(msg)
        cb openPgp.decryptMessage(privateKey,
            armored), armored

    getSigningKeyIdsArmoredMessage: (armored, cb) ->
        process.nextTick () ->
          cb armored.getSigningKeyIds()

    signCleartextMessage: (privateKey, msg, cb) ->
      process.nextTick () ->
        cb openPgp.signClearMessage([privateKey], msg)

    getSigningKeyIdsMessage: (msg, cb) ->
      process.nextTick () ->
        msg = openPgp.cleartext.readArmored(msg)
        signingKeyIds = msg.getSigningKeyIds()
        cb signingKeyIds
        
    getCleartextMessageText: (msg, cb) ->
      process.nextTick () ->
        msg = openPgp.cleartext.readArmored msg
        cb msg.getText()

    resolveKeyIdsFromStorage: (keyIds, cb) ->
      process.nextTick () ->
        unresolvedKeys = []
        resolvedKeys = []
        for keyId in keyIds
          keyFound = false
          for publicKey in keyring.publicKeys.keys
            if publicKey.primaryKey.keyid.bytes == keyId.bytes
              resolvedKeys.push publicKey
              keyFound = true

          unless keyFound
            unresolvedKeys.push keyId

        cb resolvedKeys, unresolvedKeys

    hexstrdump: (str) ->
      openPgp.util.hexstrdump str
  }
]
