google = undefined
search_youtube = undefined
youtube = undefined
google = require('googleapis')
pully = require('pully')
promises = require('promises'); 
filePath = "/home/rob/youtube"
download_video (options,callback)->  
  pully options, (err, info, filePath) ->
    callback err, info, filePath
  return  

# stolen from somewhere...ported to Coffeescript
search_youtube = (query, callback) ->
  youtube.search.list {
    part: 'snippet'
    type: 'video'
    q: query
    maxResults: 1
    order: 'date'
    safeSearch: 'moderate'
    videoEmbeddable: true
  }, (err, res) ->
    if err
      return callback(err)
    res.items.forEach (result) ->
      video = undefined
      video =
        id: result.id.videoId
        urlShort: 'http://youtu.be/' + result.id.videoId
        urlLong: 'http://www.youtube.com/watch?v=' + result.id.videoId        
        title: result.snippet.title or ''              
      youtube.videos.list {
        part: 'contentDetails'
        id: video.id
      }, (err2, data) ->
        if err2
          return callback(err2)
        if data.items.length >= 1
          data.items[0].contentDetails.duration.replace /PT(\d+)M(\d+)S/, (t, m, s) ->
            video.duration = parseInt(m) * 60 + parseInt(s)
            return
          video.definition = data.iWrite a comment...tems[0].contentDetails.definition
          callback null, video
        return
      return
    return
  return

google.options auth: 'AIzaSyC8uRTf_hJCiI5Yy0t88Kds97gaa47q6TI'
youtube = google.youtube('v3')
try -> 
  search_youtube 'Never gonna give you up' (err,res) -> 
catch err -> 
  console.log err

)