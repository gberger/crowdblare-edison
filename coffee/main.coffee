# NOTE: You *MUST* plug the LCD into an I2C slot or this will not work!
Cylon = require('cylon')
moment = require('moment')
Parse = require('parse').Parse

writeToScreen = (screen, message) ->
  i = 0
  
  parts = message.match(/.{1,16}/g)
  screen.setCursor 0, 0
  screen.write parts[0]
  screen.setCursor 1, 0
  screen.write parts[1]
  
  if parts.length > 2
    itv = setInterval ->
      i += 1 
      i %= (parts.length - 1)
      screen.setCursor 0, 0
      screen.write parts[i]
      screen.setCursor 1, 0
      screen.write parts[i+1]
    , 3200


Parse.initialize '8cv1fKiuMBrOdXVhvZLzuyzIraW4a5Hlqnn2PY8J', 'Rv6Q9wI9DNXYcGw5EaebEcUBAeWn5VWjzh5RslbW'
Edison = Parse.Object.extend("Edison")
Song = Parse.Object.extend("Song")

getCurrentSong = (cb) ->
  query = new Parse.Query(Edison)
  query.equalTo("twilioNumber", "+14043692348")
  query.find
    success: (results) ->
      edison = results[0]
      song = edison.get('currentPlaylist')[edison.get('currentSong')]

      query2 = new Parse.Query(Song)
      query2.equalTo("videoId", song.id)
      query2.find
        success: (results) ->
          title = results[0].get('title')
          cb(title) if typeof cb is 'function' 

Cylon
  .robot()
  .connection('edison', adaptor: 'intel-iot')
  .device('screen', driver: 'upm-jhd1313m1', connection: 'edison')
  .device('button', driver: 'button', pin: 4, connection: 'edison')
  .on 'ready', (my) ->
    itv = null
    setInterval ->
      getCurrentSong (song) ->
        clearInterval(itv)
        itv = writeToScreen my.screen, song
    , 20*1000
  .start()
