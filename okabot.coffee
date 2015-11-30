###
DocomoAPIの雑談機能をそのままつかっただけのBOT
GASで使用するには、Javascriptへコンパイルする必要があります。
APIの説明はこちら https://dev.smt.docomo.ne.jp/?p=docs.api.page&api_name=dialogue&p_name=api_1#tag01
token,apikeiは各自設定が必要です
###
token = '<<Slackのtoken>>'
apikey = 'Docomo API Key'
bot_name = 'okabot'
bot_icon = ':okamoto:'
dialogueUrl = 'https://api.apigw.smt.docomo.ne.jp/dialogue/v1/dialogue?APIKEY=' + apikey
#var bot_icon = ":robot_face:";

doPost = (e) ->
  app = SlackApp.create(token)
  if e.parameter.user_name == 'slackbot'
    return null

  message = getMessage(e.parameter.text)
  reg = new RegExp('@' + bot_name + '|' + bot_name, 'g')
  if !message.match(reg)
    return null
  message = message.replace(reg, '').trim()

  re1 = /ちょうだい|ください|くれ|画像/
  if message.match(re1)
    mes = message.replace(re1, '').trim()
    postImage app, e, mes
  else
    zatsudanBot app, e, message
  return

postImage = (app, e, mes) ->
  url = getImageUrl(mes)
  response = app.postMessage(e.parameter.channel_id, url,
    username: bot_name
    icon_emoji: bot_icon)
  return

getImageUrl = (query) ->
  url = 'http://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=' + encodeURI(query)
  response = UrlFetchApp.fetch(url)
  content = JSON.parse(response.getContentText())
  res = content.responseData.results
  ind = Math.floor(Math.random() * (res.length + 1))
  content.responseData.results[ind].url

zatsudanBot = (app, e, message) ->
  responseMessage = getDialogueMessage(e.parameter.user_name, message)
  response = app.postMessage(e.parameter.channel_id, responseMessage,
    username: bot_name
    icon_emoji: bot_icon)
  return

getMessage = (mes) ->
  mes.trim()

getDialogueMessage = (userId, mes) ->
  contextId = 'context' + userId
  dialogue_options = 'utt': mes
  props = PropertiesService.getScriptProperties()
  context = props.getProperty(contextId)
  if context
    dialogue_options.context = context
  options =
    'method': 'POST'
    'contentType': 'text/json'
    'payload': JSON.stringify(dialogue_options)
  response = UrlFetchApp.fetch(dialogueUrl, options)
  content = JSON.parse(response.getContentText())
  props.setProperty contextId, content.context
  content.utt

test = ->
  e = parameter:
    text: '@okabot たわけ'
    user_name: 'test'
    channel_id: 'C0EBH8FS7'
  doPost e
  return
