class LineBotController < ApplicationController
  require 'line/bot'

  URL_DOMAIN = "http://localhost:3000"

  # 環境変数はheroku側で管理
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

    events.each { |event|
      message = {
        type: 'text',
        text: "友達登録ありがとうございます！\n初めて利用する場合は学生番号を登録してください。"
      }
      client.reply_message(event['replyToken'], message)

      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          if event.message["text"].include?("1")
            message = {
              type: 'text',
              text: "学生番号を登録します。"
            }
            client.reply_message(event['replyToken'], message)
          elsif event.message["text"].include?("2")
            message = {
              type: 'text',
              text: "就職活動を報告します。"
            }
            client.reply_message(event['replyToken'], message)
          elsif event.message["text"].include?("3")
            message = {
              type: 'text',
              text: "nosakaneのホームページにアクセスします。"
            }
            client.reply_message(event['replyToken'], message)
          else
            message = {
              type: 'text',
              text: "リッチメニューから選んでください。"
            }
            client.reply_message(event['replyToken'], message)
          end
        when Line::Bot::Event::MessageType::Image
          message = {
            type: 'text',
            text: "写真なんか送ってくんじゃねぇ！！"
          }
          client.reply_message(event['replyToken'], message)
        end
      end
    }
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
        {
          "type": "message",
          "label": "はい",
          "text": "はい"
        },
        {
          "type": "message",
          "label": "いいえ",
          "text": "いいえ"
        }
        ],
          "text": msg
      }
}
end