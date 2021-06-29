class LineBotController < ApplicationController
  require 'line/bot'

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
      # Studentテーブルにイベントのユーザーが存在しているか検索
      student = Student.where(line_account_id: userId).first

      case event
      when Line::Bot::Event::Follow#友達追加
        student = Student.new
        user = User.new
        student.line_account_id = userId
        student.flg = 1
        message = {
                type: 'text',
                text: "友達登録完了。"
              }
        client.reply_message(event['replyToken'], message)
        student.save
      when Line::Bot::Event::Unfollow#友達解除
        student.destroy
        s = Student.where(student_id: student.student_id).first
        s.register = false
        s.save
      when Line::Bot::Event::Message# メッセージ受信
        message = {
          type: 'text',
          text: "学生番号を入力"
        }
        client.reply_message(event['replyToken'], message)

        # Studentテーブルにあるか確認
        if s = Student.where(student_id: event.message['text']).first
          # 生徒の名前の確認
          message = check_button(s.name + "さんですか？")
          user.student_id = s.student_id
          client.reply_message(event['replyToken'], message)
        else # 生徒の名前を登録する
          message = {
          type: 'text',
          text: "該当の学生ナンバーがありません。\nもう一度学生ナンバーを入力してください"
          }
          client.reply_message(event['replyToken'], message)
        end
        
        user.save
      end

      client.reply_message(event['replyT oken'], message)
    end

    head :ok
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