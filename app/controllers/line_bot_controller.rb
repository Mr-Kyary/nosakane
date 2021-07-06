class LineBotController < ApplicationController
  require 'line/bot'

  URL_DOMAIN = "http://localhost:3000".freeze

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
      p event#デバッグ用
      ###################################
      # stateカラムは整数値
      # 0: 初期値
      # 1: 友達登録している（ブロックしていない）
      # 2: 
      # 3: 投稿フェーズの段階
      # 4: 
      ###################################
      # LINEアカウントIDを取得
      userId = event['source']['userId']

      # studentテーブルにLINEアカウントIDが存在しない場合→studentデータとLINEアカウントの紐づけがない=新規登録段階
      unless student = Student.find_by(line_account_id: userId)
        # 仮のstudentデータを作成する
        student = Student.new(line_account_id: userId)
      end

      #  投稿機能フェーズの途中の場合、作成途中の投稿
      if student.report_id_in_progress
        report = Report.find(student.report_id_in_progress)
      end
      
      case event
      when Line::Bot::Event::Postback
        p event
        if report.planned_at = event["postback"]["params"]["datetime"]
          report.save
          student.state = 4
          student.save
          message = {
            type: 'text',
            text: "詳細を入力してください。"
          }
          client.push_message(userId, message)
        else
          message = {
            type: 'text',
            text: "日付を確認できません。"
          }
          client.push_message(userId, message)
        end
      when Line::Bot::Event::Follow]
        
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
      when Line::Bot::Event::Unfollow
        # studentsの不完全なデータがあれば、全部削除
        student.state = nil
				student.report_id_in_progress = nil
        student.save
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          if event.message['text'].include?(">活動報告")
            student.state = 2
						student.save
          elsif event.message['text'].include?(">活動報告の確認")
            student.state = 99
						student.save
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

            user = User.find_by(student_id: student.student_id)
            report = Report.new(
              user_id: user.id,
              report_detail: "#{student.name} in progress of creatig a report."
            )
            report.save

            student.update(report_id_in_progress: report.id)

            student.save
          when 3
            ## 機能（種別を入れる）
            if event.message['text'].include?("あ")
              # インターンシップ
              report.report_type_id = 1
						elsif event.message['text'].include?("い")
              # 就活イベント
              report.report_type_id = 2
            elsif event.message['text'].include?("う")
              # 説明会
              report.report_type_id = 3
            elsif event.message['text'].include?("え")
              # 筆記試験
              report.report_type_id = 4
            elsif event.message['text'].include?("お")
              # 面接
              report.report_type_id = 5
            else
              message = {
                type: "text",
                text: "番号が確認できません。\nもう一度入力してください。\n1️⃣インターンシップ\n2️⃣就活イベント\n3️⃣説明会\n4️⃣筆記試験\n5️⃣面接"
              }
              client.push_message(userId, message)
            end

            student.save
            report.save

            message = {
              type: 'text',
              text: "日付を選択してください。(日付は送れない)"
            }
            client.push_message(userId, message)

            message = {
              "type": "template",
              "altText": "datetime_picker",
              "template": {
                "type": "buttons",
                "thumbnailImageUrl": "https://upload.wikimedia.org/wikipedia/en/thumb/a/a6/Pok%C3%A9mon_Pikachu_art.png/220px-Pok%C3%A9mon_Pikachu_art.png", 
                "imageAspectRatio": "rectangle", 
                "imageSize": "cover", 
                "imageBackgroundColor": "#FFFFFF", 
                "title": "メニュー",
                "text": "以下より選択してください。",
                "defaultAction": {
                  "type": "uri",
                  "label": "View detail",
                  "uri": "https://arukayies.com/"
                },
                "actions": [
                  {
                    "type": "datetimepicker",
                    "label": "日時を選択してください。",
                    "data": "action=settime",
                    "mode": "datetime",
                    "initial": "2020-12-25t00:00",
                    "max": "2030-01-01t00:00",
                    "min": "2020-01-01t00:00"
                  }
                ]
              }
            }
            client.push_message(userId, message)

          when 4
            report.report_detail = event.message['text']
            message = {
              type: 'text',
              text: "登録しました。"
            }
            client.push_message(userId, message)
            student.state = 1
            student.save
            report.save
          ###################################投稿機能フェーズ ここまで
          when 99
            message = {
              type: 'text',
              text: "未実装の機能です！\n坂根先生が作ります"
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
        when Line::Bot::Event::MessageType::Sticker
          message = {
            type: 'image',
            originalContentUrl: "https://f.easyuploader.app/20210701234555_67436a6d.png",
            previewImageUrl: "https://f.easyuploader.app/20210701234555_67436a6d.png"
          }
          client.reply_message(event['replyToken'], message)
          message = {
            type: 'text',
            text: "坂根スタンプ、LINEスタンプストアで好評発売中！"
          }
          client.push_message(userId, message)
        end
      end
    }
  end
end