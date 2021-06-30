class LineBotController < ApplicationController
  require 'line/bot'

  # 環境変数はheroku側で管理
  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']

    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end

    events = client.parse_events_from(body)

    events.each do |event|
      # イベントのユーザーのlineIdを取得
      userId = event['source']['userId']
      # Userlineテーブルにイベントのユーザーが存在しているか検索
      user = Userline.where(line_id: userId).first

      case event
        #友達追加
      when Line::Bot::Event::Follow

        student = Student.new
        message = {
                type: 'text',
                text: "友達登録ありがとうございます！\n下記URLよりユーザー登録をしてください。\nhttps://nosakane.herokuapp.com/users/sign_in"
              }
        client.reply_message(event['replyToken'], message)
      end
    end
  end

  private
  def check_button(msg)
    {
      "type": "template",
      "altText": "this is a confirm template",
      "template": {
        "type": "confirm",
        "actions": [
            {"type": "message", "label": "はい", "text": "はい"},
            {"type": "message", "label": "いいえ", "text": "いいえ"}
        ],
        "text": msg
      }
    }
  end
end