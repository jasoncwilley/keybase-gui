@keybaseGui.factory 'keybaseGuiUpdater', ['$http', '$rootScope',
'keybaseGuiConfig', ($http, $rootScope, keybaseGuiConfig) ->
  
  url = require("url")
  os = require('os')
  http = require('http')
  request = require('request')
  progress = require('request-progress')
  fs = require('fs')

  if process.platform.match(/^win/)
    ds = "\\"
  else
    ds = "/"

  pathfrags = process.execPath.split(ds)
  __APPDIR = ''
  len = pathfrags.length
  for frag, index in pathfrags when index < len-1
    __APPDIR += frag + ds
  console.log pathfrags

  getRemoteDownloadLink = (version) ->
    server = keybaseGuiConfig.updateServer
    name ="keybase-gui"

    platform = os.platform()
    plat = ""

    if platform == 'linux'
      plat = "linux"
      if os.arch() == "x64"
        plat += "64"
      else
        plat += "32"
    else if platform == 'win32'
      plat = "win"
    else if platform == "darwin"
      plat = "mac"

    "#{server}#{name}.#{plat}.#{version}.zip"

  getNwDownloadLink = (version) ->
    server = keybaseGuiConfig.updateServer
    name ="keybase-gui"

    "#{server}#{name}.#{version}.nw"

  downloadNw = (url, cb) ->
    $rootScope.$broadcast('updater:nw-update-download-started', {url: url})

    file = __APPDIR + 'keybase-gui.update.nw'
    
    progress(request(url))
    .on 'progress', (state) ->
      console.log state
      $rootScope.$broadcast('updater:nw-update-download-progress', state)
    .on 'error', (err) ->
      cb err, null
    .pipe fs.createWriteStream 'keybase-gui.update.nw'
    .on 'close', ->
      cb null, file
      $rootScope.$broadcast('updater:nw-update-download-finished',
        {file: file})

  replaceCurrentNw = (downloadedNw, cb) ->
    console.log downloadedNw
    await fs.rename __APPDIR + 'keybase-gui.nw',
     __APPDIR + 'keybase-gui.old.nw', defer err
    await fs.rename __APPDIR + 'keybase-gui.update.nw',
     __APPDIR + 'keybase-gui.nw', defer err

  $rootScope.$on 'updater:nw-update-available', (event, args) ->
    downloadLink = getNwDownloadLink(args.version)
    console.log downloadLink
    await downloadNw downloadLink, defer err, downloadedNw
    await replaceCurrentNw downloadedNw, defer err

  {
    checkForUpdates: ->
      alert keybaseGuiConfig.version
      #return if keybaseGuiConfig.debug

      await $http.get(keybaseGuiConfig.updateServer + 'version.json')
      .success defer data, status

      remoteVersion = parseInt data.version
      localVersion = keybaseGuiConfig.version

      remoteBinaryVersion = data.binaryVersion
      localBinaryVersion = keybaseGuiConfig.binaryVersion

      semver = require('semver')

      if semver.gt(remoteBinaryVersion, localBinaryVersion)
        downloadLink = getRemoteDownloadLink remoteVersion
        $rootScope.$broadcast('updater:binary-update-available',
         {url: downloadLink})

      else if remoteVersion > localVersion
        $rootScope.$broadcast('updater:nw-update-available',
         {version: remoteVersion})
  }

]