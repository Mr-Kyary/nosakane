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
          elsif event.message['text'].include?(">活動報告の確認")
            studen.state = 99
          end
          
          case student.state
          ###################################投稿機能フェーズ
          ###################仕様####################
          # student.stateが2~8まで間は投稿機能フェーズとする
          # 2 
          # 3 
          # 4 
          # 5 
          # 6 
          # 7 
          # 8 
          ###############仕様ここまで################
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
            report = Report.new
          when 3
            ## 機能（種別を入れる）
            case event.message['text']
            when 1
              # インターンシップ
              report.report_type_id = 1
            when 2
              # 就活イベント
              report.report_type_id = 2
            when 3
              # 説明会
              report.report_type_id = 3
            when 4
              # 筆記試験
              report.report_type_id = 4
            when 5
              # 面接
              report.report_type_id = 5
            else
              message = {
                type: 'text',
                text: "番号が確認できません。"
              }
              client.push_message(userId, message)
              student.state = 2
            end

            message = {
              type: 'text',
              text: "日付(月)を入力してください。"
            }
            client.push_message(userId, message)
            report.planned_at = Datetime.new(year: Date.today.year)
            student.state = 5
          when 4
            ## 機能（予定月を入れる）
            if event.message['text'].between?(1, 12)
              report.planned_at = Datetime.new(report.planned_at.year, event.message['text'])
            end
            message = {
              type: 'text',
              text: "予定日を入力してください。"
            }
            client.push_message(userId, message)
            student.state = 6
          when 5
            ## 機能（予定日を入れる）
            report.planned_at = Datetime.new(report.planned_at.year, report.planned_at.month, event.message['text'])
            if event.message['text'].between?(1, 12)
              report.planned_at[:month] = event.message['text']
            else

            end
            message = {
              type: 'text',
              text: "時間を入力してください。"
            }
            client.push_message(userId, message)
            student.state = 6
          when 6
            ## 機能（時間を入れる）
            report.planned_at = Datetime.new(report.planned_at.year, report.planned_at.month,  report.planned_at.day, event.message['text'])
            message = {
              type: 'text',
              text: "詳細を入力してください。"
            }
            client.push_message(userId, message)
            student.state = 7
          when 7
            message = {
              type: 'text',
              text: "以下の内容で登録します。"
            }
            client.push_message(userId, message)
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