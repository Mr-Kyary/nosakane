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

    events.each do |event|
      # イベントのユーザーのlineIdを取得
      userId = event['source']['userId']
      # Userlineテーブルにイベントのユーザーが存在しているか検索
      student = Student.where(line_account_id: userId).first

      case event
      when Line::Bot::Event::Follow#友達追加
        message = {
                type: 'text',
                text: "1:ユーザー登録を完了してください。\n#{URL_DOMAIN}/users/sign_up\n\n\n2:ユーザー登録が完了したら、学生ナンバーを入力してください！"
              }
        client.reply_message(event['replyToken'], message)
      when Line::Bot::Event::Unfollow#友達解除
        student.line_account_id = nil
        student.save
      when Line::Bot::Event::Message#メッセージ受信
        userId = event['source']['userId']# イベントのユーザーのlineIdを取得
        student = Student.where(line_account_id: userId).first# Studentテーブルにイベントのユーザーが存在しているか検索
        case event.type
        when Line::Bot::Event::MessageType::Text
          case /[0-9]{6}/ =~ event.message['text']
          when 0
            student_id = event.message['text']
            message = {
              type: 'text',
              text: "学生番号を登録します。"
            }
            student.student_id = student_id
          end
        end
      end
      head :ok
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