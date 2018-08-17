class EventController < ApplicationController
  def index
  @current_week = []
  @next_week = []
  @event_time = ['00:00','01:00','02:00','03:00','04:00','05:00','06:00','07:00','08:00','09:00','10:00','11:00','12:00',
                 '13:00','14:00','15:00','16:00','17:00','18:00','19:00','20:00','21:00','22:00','23:00','24:00']
  week_start = Date.today.beginning_of_week
    i=0
    7.times do
      @current_week.append(week_start+i)
      @next_week.append(Date.today.next_week + i)
      i = i+1
    end
  if params[:show] == 'next_week'
    @nw=true
    @current_week = @next_week
  end
@events1 = Event.where(:event_day => @current_week[0].strftime('%d/%m/%Y')).order('event_time asc')
  @events2 = Event.where(:event_day => @current_week[1].strftime('%d/%m/%Y')).order('event_time asc')
  @events3 = Event.where(:event_day => @current_week[2].strftime('%d/%m/%Y')).order('event_time asc')
  @events4 = Event.where(:event_day => @current_week[3].strftime('%d/%m/%Y')).order('event_time asc')
  @events5 = Event.where(:event_day => @current_week[4].strftime('%d/%m/%Y')).order('event_time asc')
  @events6= Event.where(:event_day => @current_week[5].strftime('%d/%m/%Y')).order('event_time asc')
  @events7= Event.where(:event_day => @current_week[6].strftime('%d/%m/%Y')).order('event_time asc')

  end

  def tamriel_adv_event
    e = Event.new

    e.event_name = params[:tamriel_adv_event][:event_name]
    e.event_name_translit=Translit.convert(params[:tamriel_adv_event][:event_name].gsub(' ','-').gsub(/[?!*.,:; ]/, ''), :english)
    e.event_day = params[:event_day]
    e.event_time = params[:event_time]
    e.event_type = 'tamriel_adv'
    e.event_creator = current_player.id
    e.save
    redirect_to events_path

  end
end
