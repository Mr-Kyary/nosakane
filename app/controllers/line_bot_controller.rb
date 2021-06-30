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

    state = 0

    events.each { |event|
      ###################################
      # stateカラムは4桁の数字で構成
      # ① ユーザ登録の有無 1:yes, 2:no
      # ② 
      # ③ 投稿フェーズの段階 
      # ④
      ###################################
      case event
      when Line::Bot::Event::Follow
        message = {
          type: 'text',
          text: "友達登録ありがとうございます！\n初めて利用する場合は学生番号を登録してください。"
        }
        client.reply_message(event['replyToken'], message)
      when Line::Bot::Event::Message
        case 
        when event.type == Line::Bot::Event::MessageType::Text
          if event.message['text'].include?(">学生番号")
            message = {
              type: 'text',
              text: "学生番号の登録を行います。\n学生番号を入力してください。"
            }
            client.reply_message(event['replyToken'], message)
            # if文抜けるためのstateが必要
            student_id = event.message['text']
            message = {
              type: 'text',
              text: 'student name.'#が入力された学生番号で名前の確認
            }
            client.reply_message(event['replyToken'], check_button(message))
          elsif event.message['text'].include?(">活動報告")

          elsif event.message['text'].include?(">活動報告の確認")

          end
        when Line::Bot::Event::MessageType::Image
          message = {
            type: 'image',
            originalContentUrl: "https://f.easyuploader.app/20210630225256_6c393373.jpg",
            previewImageUrl: "https://f.easyuploader.app/20210630225256_6c393373.jpg"
          }
          client.reply_message(event['replyToken'], message)  
        end
      end
    }
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
end