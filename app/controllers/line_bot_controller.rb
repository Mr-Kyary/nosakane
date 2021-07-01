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
      userId = event['source']['userId']
      unless student = Student.find_by(line_account_id: userId)
        student = Student.new
      end

      case event
      when Line::Bot::Event::Follow
        message = {
          type: 'text',
          text: "nosakaneへようこそ！"
        }
        client.push_message(userId, message)
        message = {
          type: 'text',
          text: "友達登録ありがとうございます。\n初めて利用する場合は下記URLより利用登録を行って下さい。\n\n#{URL_DOMAIN}/users/sign_up?line_account_id=#{userId}"
        }
        client.push_message(userId, message)
        message = {
          type: 'text',
          text: "利用登録が完了している場合は、メニューからやりたいことを選んでください！"
        }
        client.push_message(userId, message)
        student.state = 1
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          if event.message['text'].include?(">活動報告")
            student.state = 2
          end
          
          case student.state
          when 2
            message = {
              type: 'text',
              text: "活動報告をします。\n下記より報告する活動種別を選んでください。"
            }
            client.push_message(userId, message)
            message = {
              type: 'text',
              text: "1️⃣インターンシップ\n2️⃣就活イベント\n3️⃣説明会\n4️⃣筆記試験\n5️⃣面接"
            }
            client.push_message(userId, message)
            student.state = 3
          when 3
            ## 機能（種別を入れる）
            message = {
              type: 'text',
              text: "日付を入力してください。"
            }
            client.push_message(userId, message)
            student.state = 4
          when 4
            ## 機能（日付を入れる）
            message = {
              type: 'text',
              text: "時間を入力してください。"
            }
            client.push_message(userId, message)
            student.state = 5
          when 5
            ## 機能（時間を入れる）
            message = {
              type: 'text',
              text: "詳細を入力してください。"
            }
            client.push_message(userId, message)
            student.state = 6
          when 6
            message = {
              type: 'text',
              text: "以下の内容で登録します。"
            }
            client.push_message(userId, message)
          end
        when Line::Bot::Event::MessageType::Image
          message = {
            type: 'image',
            originalContentUrl: "https://f.easyuploader.app/20210701234555_67436a6d.png",
            previewImageUrl: "https://f.easyuploader.app/20210701234555_67436a6d.png"
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
      "text": msg,
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
    }
  }
  end
end