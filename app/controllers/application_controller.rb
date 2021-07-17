class ApplicationController < ActionController::Base
  # CSRFトークンの不整合があった場合→セッションを空にする
  protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:student_id])
  end

  def to_signin
    redirect_to "/users/sign_in"
  end

  def to_top
    redirect_to "/"
  end

  helper_method :to_signin, :to_top
end
