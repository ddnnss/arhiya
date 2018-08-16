class EventController < ApplicationController
  def index
  @current_week = []
  @next_week = []
  week_start = Date.today.beginning_of_week
    i=0
    7.times do
      @current_week.append(week_start+i)
      i = i+1

    end

  end

  def tamriel_adv_event


  end
end
