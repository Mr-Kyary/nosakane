class ApplicationController < ActionController::Base
  client = Line::Bot::Client.new { |config|
    config.channel_secret = "<channel secret>"
    config.channel_token = "<channel access token>"
}
response = client.get_profile("<userId>")
case response
when Net::HTTPSuccess then
  contact = JSON.parse(response.body)
  p contact['displayName']
  p contact['pictureUrl']
  p contact['statusMessage']
else
  p "#{response.code} #{response.body}"
end
end
