@keybaseGui.factory 'keybaseApi', ['$http', ($http) ->
  baseUrl = "https://keybase.io/_/api/1.0"

  get_salt = (username, cb) ->
    url = "#{baseUrl}/getsalt.json?email_or_username=#{username}"
    await $http.get(url).then defer result
    if result.status != 200
      cb new Error("The server answered with #{result.status}!"), null, null
    else
      salt = (new Buffer result.data.salt, 'hex')
      login_session = new Buffer result.data.login_session, 'base64'
      cb null, salt, login_session

  gen_pwh = (password, salt, cb) ->
    triplesec = require('triplesec')

    enc = new triplesec.Encryptor {
      key: new Buffer(password, 'utf8')
      version: 3
    }
    extra_keymaterial = 32 + 12
    await enc.resalt { salt, extra_keymaterial }, defer err, km
    _salt = enc.salt.to_buffer()
    _pwh = km.extra[0...32]
    _pwh_version = triplesec.CURRENT_VERSION

    cb err, _pwh, _salt, _pwh_version

  gen_hmac_pwh = (passphrase, salt, login_session, cb) ->
    await gen_pwh passphrase, salt, defer err, pwh

    crypto = require('crypto')
    hmac_pw = crypto.createHmac('SHA512', pwh).update(login_session).digest()

    hmac_pwh = hmac_pw.toString('hex')

    cb err, hmac_pwh
  {
    login: (username, password, cb) ->
      await get_salt username, defer err, salt, login_session
      await gen_hmac_pwh password, salt, login_session, defer err, hmac_pwh

      url = "#{baseUrl}/login.json"

      await $http.post(url, {
        email_or_username: username,
        hmac_pwh: hmac_pwh,
        login_session: login_session.toString('base64')})
        .then(defer result)

      if result.data.status.code == 0
        cb null, result.data.session, result.data.me
      else
        cb new Error(result.data.status.desc), null, null

    lookup: (username, cb) ->
      url = "#{baseUrl}/user/lookup.json?username=#{username}"

      await $http.get(url).then defer result

      if result.data.status.code != 0
        cb new Error(result.data.status.desc), null
      else
        cb null, result.data.them

    logout: (cb) ->
      if !!$http.defaults.headers.common.Cookie
        cb new Error("The user wasn't signed in!")
      else
        $http.post("#{baseUrl}/session/killall.json").then defer result
        $http.defaults.headers.common.Cookie = ""
        cb(null)
  }
]
