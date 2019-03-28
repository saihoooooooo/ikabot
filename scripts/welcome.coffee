# Description:
#   welcome
#
# Author:
#   saihoooooooo

icons = [
  { name: 'アオリ', img: 'aori.png', messages: [
    'ようこそ！'
    'イカ、よろしくーーー！'
  ] }
  { name: 'ホタル', img: 'hotaru.png', messages: [
    'いらっしゃ〜い'
    'イカ、よろしく〜〜〜'
  ] }
  { name: 'ヒメ', img: 'hime.png', messages: [
    'ヨロシク！'
    'こんちゃーっ！'
  ] }
  { name: 'イイダ', img: 'iida.png', messages: [
    'はじめまして！よろしくお願いします〜'
    'いらっしゃいませ〜！'
  ] }
]

channelId = {
  random: 'C0GHW93U2'
  roller: 'C3QCNCWBS'
}

welcome = (robot, msg) ->
    icon = msg.random icons

    message = "@#{msg.message.user.name} #{msg.random icon.messages}"

    attachments = [
      fallback: 'はじめての方へ'
      color: '#36a64f'
      pretext: ''
      title: 'はじめての方へ'
      title_link: process.env.SPLATHON_SLACK_WELCOME_LINK
      text: 'Splathon Slackのご利用ルールです'
      footer: 'Splathon'
      fields: [
        title: '！必ずご一読ください！'
        value: process.env.SPLATHON_SLACK_WELCOME_LINK
        short: false
      ]
      footer: 'Splathon'
      ts: '1511263020'
    ]

    options =
      link_names: 1
      username: icon.name
      icon_url: "http://saihoooooooo.org/#{icon.img}"
      attachments: attachments

    client = robot.adapter.client
    client.web.chat.postMessage(msg.envelope.room, message, options)

module.exports = (robot) ->
  robot.enter (msg) ->
    if msg.message.user.room is channelId.random
      welcome robot, msg
    else if msg.message.user.room is channelId.roller
      msg.send "@#{msg.message.user.name} おっすローラー"

  robot.respond /welcome$/i, (msg) ->
      welcome robot, msg
