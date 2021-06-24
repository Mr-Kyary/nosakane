class ApplicationController < ActionController::Base
  # CSRFトークンの不整合があった場合→セッションを空にする
  protect_from_forgery with: :null_session

  def to_signin
    redirect_to "/users/sign_in"
  end

  helper_method :to_signin
end
