# NOTE: You *MUST* plug the LCD into an I2C slot or this will not work!

writeToScreen = (screen, message) ->
  screen.setCursor 0, 0
  screen.write message
  return

Cylon = require('cylon')
moment = require('moment')
Cylon.robot(name: 'LCD').connection('edison', adaptor: 'intel-iot').device('screen',
  driver: 'upm-jhd1313m1'
  connection: 'edison').device('button',
  driver: 'button'
  pin: 4
  connection: 'edison').on('ready', (my) ->
  setInterval ->
    writeToScreen my.screen, moment().format('h:mm:ss a')
    return
  my.button.on 'release', ->
    console.log 'button'
    writeToScreen my.screen, 'button'
    return
  return
).start()