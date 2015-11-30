# okabot
Bot program works on GAS.

### Explanation
DocomoAPIの雑談機能をそのままつかっただけのBOTに、/ちょうだい|ください|くれ|画像/ にマッチする場合は画像を拾ってくる処理を追加しているだけです。

GASで使用するには、Javascriptへコンパイルする必要があります。

DocomoAPIの説明はこちら https://dev.smt.docomo.ne.jp/?p=docs.api.page&api_name=dialogue&p_name=api_1#tag01

token,apikey は それぞれ Slackのtokenと、DocomoAPI のAPI Key です。それぞれ設定が必要です。
