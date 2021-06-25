class CalendarController < ApplicationController
  def index
    @reports = Report.all
    render :json => @reports
  end
end