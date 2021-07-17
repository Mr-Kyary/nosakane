class HomeController < ApplicationController
  def top
  end

  def about
  end

  def mypage
    @reports = Report.where(user_id: current_user.id)
  end
end
