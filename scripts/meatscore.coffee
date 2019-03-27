# Description:
#   肉を採点する
#
# Author:
#   saihoooooooo

fs = require 'fs'
request = require 'request'
exec = require('child_process').exec

module.exports = (robot) ->
  robot.adapter.client.on 'raw_message', (rawmsg) ->
    msg = JSON.parse rawmsg
    if msg.type is 'message' and msg.subtype is 'file_share' and msg.text.match(/commented: 肉採点$/)
      filename = msg.file.url_private.split('/').pop()
      filepath = "img/tmp/#{filename}"
      file = fs.createWriteStream(filepath)
      options = {
        'url': msg.file.url_private_download,
        'headers': {
          'Authorization': "Bearer #{process.env.HUBOT_SLACK_TOKEN}"
        }
      }
      request
        .get(options)
        .on 'error', (err) ->
          console.log "#{err}"
        .pipe(file)
        .on 'close', (resp) ->
          exec "convert #{filepath} -resize 1000x #{filepath}", (err, stdout, stderr) ->
            apikey = process.env.A3RT_TOKEN
            url = 'https://api.a3rt.recruit-tech.co.jp/image_influence/v1/meat_score'
            exec "curl -X POST -F apikey=#{apikey} -F predict=1 -F imagefile=@#{filepath} #{url}", (err, stdout, stderr) ->
              response = JSON.parse stdout
              if response.status == 0
                if response.result.score > 9
                  comment = '伝説の肉'
                else if response.result.score > 7
                  comment = '最高の肉'
                else if response.result.score > 5
                  comment = 'おいしい肉'
                else if response.result.score > 3
                  comment = 'そこそこな肉'
                else if response.result.score > 1
                  comment = 'いまいちな肉'
                else
                  comment = '最悪の肉'
                robot.send {room: msg.channel}, "【#{comment}】スコア: #{response.result.score}"
              else
                robot.send {room: msg.channel}, "エラーが発生しました（#{response.status}）。"
              fs.unlinkSync filepath
