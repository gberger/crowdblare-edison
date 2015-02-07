# NOTE: You *MUST* plug the LCD into an I2C slot or this will not work!

writeToScreen = (screen, message) ->
  screen.setCursor 0, 0
  screen.write message

Cylon = require('cylon')
moment = require('moment')

Cylon
  .robot()
  .connection('edison', adaptor: 'intel-iot')
  .device('screen', driver: 'upm-jhd1313m1', connection: 'edison')
  .device('button', driver: 'button', pin: 4, connection: 'edison')
  .on 'ready', (my) ->
    setInterval ->
      writeToScreen my.screen, moment().format('h:mm:ss a')
    my.button.on 'release', ->
      console.log 'button'
      writeToScreen my.screen, 'button'
  .start()
