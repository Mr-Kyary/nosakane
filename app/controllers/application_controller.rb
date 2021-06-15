class ApplicationController < ActionController::Base
  # CSRFトークンの不整合があった場合→セッションを空にする
  protect_from_forgery with: :null_session
end
