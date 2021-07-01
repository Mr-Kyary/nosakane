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
      student = Student.where(line_account_id: userId).first

      case event
      when Line::Bot::Event::Follow
        student = Student.where(line_account_id: userId).first
        student = Student.new
        student.line_account_id = userId
        student.state = 1
        message = {
          type: 'text',
          text: "友達登録ありがとうございます！\n初めて利用する場合は下記URLより利用登録を行って下さい。\n\n#{URL_DOMAIN}/users/sign_up"
        }
        client.reply_message(event['replyToken'], message)
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          if event.message['text'].include?(">学生番号")
            student.state = 1
          elsif event.message['text'].include?(">活動報告")
            student.state = 2
          end
          ###################################
          # stateカラムは4桁の数字で構成
          # ① ユーザ登録の有無 1:yes, 2:no
          # ② 
          # ③ 投稿フェーズのline段階 
          # ④
          ###################################
          case student.state
          when 1, 2, 3
            case student.state
            when 1
              message = {
                type: 'text',
                text: "学生番号の登録を行います。\n学生番号を入力してください。"
              }
              client.reply_message(event['replyToken'], message)
              student.state = 2
            when 2
              if student = Student.find_by(student_id: event.message['text']).first
                message = {
                  type: 'text',
                  text: s.name + "さんで登録をします。\nよろしいでしょうか？"
                  }
                  client.reply_message(event['replyToken'], message)
                  student.state = 3
              else
                message = {
                type: 'text',
                text: "該当の学生ナンバーがありません。\nもう一度学生ナンバーを入力してください"
                }
                client.reply_message(event['replyToken'], message)
              end
            when 3
              if event.message['text'].include?("はい", "うん","yes")
                student.state = 4
              else
                student.state = 1
              end
            when 4
              message = {
                type: 'text',
                text: s.name + "さんで登録をしました。"
              }
              student.line_account_id = userId
              student.state = 2
              sstudent.save
              client.reply_message(event['replyToken'], message)
            end
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