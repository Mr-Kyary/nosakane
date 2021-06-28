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
      student = Studnets.where(line_id: userId).first

      case event
      when Line::Bot::Event::Follow#友達追加
        student = Student.new
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
        userId = event['source']['userId']
        
      end
      client.reply_message(event['replyT oken'], message)
    end

    head :ok
  end
end