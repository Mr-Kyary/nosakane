require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'google/api_client/client_secrets'
require 'google/apis/calendar_v3'
require "date"
require "fileutils"

class CalendarController < ApplicationController
  APPLICATION_NAME = 'nosakane'
  USER_ID = 'default'
  TIME_ZONE = 'Japan'

  # CalendarID
  GCAL_ID = 'abl391j0gm607hkjn6jk4d8gjo@group.calendar.google.com'
  # callback URL
  OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'

  # 事前認証
  class << self
    def authorize
      client_id = Google::Auth::ClientId.from_file("client_secret.json")
      token_store = Google::Auth::Stores::FileTokenStore.new(
        file: "tokens.yaml")
      scope = 'https://www.googleapis.com/auth/calendar'
      authorizer = Google::Auth::UserAuthorizer.new(client_id, scope, token_store)
      credentials = authorizer.get_credentials(USER_ID)
      if credentials.nil?
        raise "credentials is none..."
      end
      credentials
    end

    # Google Calendar への登録
    def insert_gcal_event(evt_start, evt_end, summary, description, location)
      service = Google::Apis::CalendarV3::CalendarService.new
      service.client_options.application_name = APPLICATION_NAME
      service.authorization = self.authorize

      # 登録するイベント内容
      h_tmp = {
        summary: summary,
        description: description,
        location: location,
        start: {
          date_time: evt_start.iso8601,
          time_zone: TIME_ZONE
        },
        end: {
          date_time: evt_end.iso8601,
          time_zone: TIME_ZONE 
        }
      }

      event = Google::Apis::CalendarV3::Event.new(h_tmp)
      service.insert_event(GCAL_ID, event)
    end
  end

end