class CalendarController < ApplicationController
  def index
    @reports = Report.all
    render :json => @reports
  end
  def user
    @users = User.all
    render :json => @users
  end
  def student
    @students = Student.all
    render :json => @students
  end
end