@keybaseGui.factory 'openPGP', [ () ->
  openPgp = require('openpgp')
  inited = false
  {
    init: () ->
      unless inited?
        openPgp.init()
        inited = true

    readPublicKey: (keyString) ->
      openPgp.key.readArmored(keyString)

    encryptMessage: (publicKey, plaintext) ->
      openPgp.encryptMessage [publicKey], plaintext
  }
]
