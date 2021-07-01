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
      ###################################
      # stateカラムは整数値
      # 0: 初期値
      # 1: 友達登録している（ブロックしていない）
      # 2: 
      # 3: 投稿フェーズの段階
      # 4: 
      ###################################
      userId = event['source']['userId']
      
      unless student = Student.find_by(line_account_id: userId)
        student = Student.new(line_account_id: userId)
      end
      
      case event
      when Line::Bot::Event::Follow
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

          case student.state
          when nil
            message = {
              type: 'text',
              text: student.name + "学生番号を登録します\n学生番号を入力してください。"
            }
          when 1
            message = {
              type: 'text',
              text: student.name + "さんで登録をします。"
            }
            student.line_account_id = userId
            student.state = 2
            student.save
            client.reply_message(event['replyToken'], message)
          else
            message = {
            type: 'text',
            text: "該当の学生ナンバーがありません。\nもう一度学生ナンバーを入力してください"
            }
            client.reply_message(event['replyToken'], message)
          end
          elsif student.state == 2#student.state == 2 ←Studentで作成したインスタンスがない場合は？
            create_report_on_line
          end
        when Line::Bot::Event::MessageType::Image
          reply_sakane_picture
        end
      end
    }
  end

  private
  def check_button(msg)# LINEのYES/NOの確認メッセージを表示させる
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

  def create_report_on_line
    message = {
      type: 'text',
      text: "投稿を完了しました。"
      }
      client.reply_message(event['replyToken'], message)
  end
  
  def reply_sakane_picture
    message = {
      type: 'image',
      originalContentUrl: "https://f.easyuploader.app/20210630225256_6c393373.jpg",
      previewImageUrl:    "https://f.easyuploader.app/20210630225256_6c393373.jpg"
    }
    client.reply_message(event['replyToken'], message)
  end
end