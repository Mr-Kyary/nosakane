class LineBotController < ApplicationController
  require 'line/bot'

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
          user = Userline.new
          user.line_id = userId
          user.flg = 1
          message = {
                  type: 'text',
                  text: "友達登録ありがとうございます！\n学生ナンバーを入力してください！"
                }
          client.reply_message(event['replyToken'], message)
          user.save
        #友達解除
        when Line::Bot::Event::Unfollow
          user.destroy
          s = Student.where(student_id: user.student_id).first
          s.register = false
          s.save

        # メッセージ受信
        when Line::Bot::Event::Message
        # イベントのユーザーのlineIdを取得
        userId = event['source']['userId']
        # Userlineテーブルにイベントのユーザーが存在しているか検索
        user = Userline.where(line_id: userId).first
        # line_idがuserlinesに入っているか確認
        # 入っていたらstudent_idを確認。空もしくは学生テーブルに対象データがあるか確認
        # 入っていないときまた上記の条件が一致しないときはstudent_idが空flgが1のデータを登録

        case event.type
          when Line::Bot::Event::MessageType::Text
            case user.flg
              when 1 # 新規登録            
                if s = Student.where(student_id: event.message['text']).first
                message = check_button(s.s_name + "さんですか？")
                user.student_id = s.student_id
                user.flg = 3
                client.reply_message(event['replyToken'], message)
                else
                  message = {
                  type: 'text',
                  text: "該当の学生ナンバーがありません。\nもう一度学生ナンバーを入力してください"
                  }
                  client.reply_message(event['replyToken'], message)
                end
                user.save
              when 2
                seito = Student.where(student_id: user.student_id).first
                #問い合わせ内容を先生に転送
                if seito
                  ReceiveInfo.create(line_id: event['source']['userId'] , message: event.message['text'] , name:seito.s_name)
                  message_teacher = {
                    type: 'text',
                    text: seito.s_name + "からのメッセージです。\n" + event.message['text']
                  }
                  client.multicast(ENV["LINE_USER_ID"], message_teacher)
                end
              when 3
                if event.message['text'] == "はい"
                  s = Student.where(student_id: user.student_id).first
                  user.flg = 2
                  s.register = true
                  message = {
                    type: 'text',
                    text: "こんにちは" + s.s_name + "さん"
                    }
                  client.reply_message(event['replyToken'], message)
                  user.save
                  s.save
                elsif event.message['text'] == "いいえ"
                  user.student_id = nil
                  user.flg = 1
                  message = {
                    type: 'text',
                    text: "学生ナンバーを入力してください"
                  }
                  client.reply_message(event['replyToken'], message)
                  user.save
                else
                  message = {
                    type: 'text',
                    text: "\"はい\"か\"いいえ\"を入力してください"
                  }
                  client.reply_message(event['replyToken'], message)
                end
            end         
        end
      end
      head :ok
    end
  end

  private
  # 環境変数はheroku側で管理
  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end
end
