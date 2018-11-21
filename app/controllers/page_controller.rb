class PageController < ApplicationController
  before_action :get_cart, :check_activity, :set_activity, :check_ban
   require 'nokogiri'
  require 'open-uri'

def check_ban
  if player_banned
    session[:active] = false
    reset_session
    flash[:ban] = 'Аккаунт заблокирован'
    redirect_to '/'
  end
end
  def check_activity
    if logged_in?
      if current_player.updated_at + 1.hour < Time.now
        session[:active] = false
        reset_session
        redirect_to '/'
      end
    end
  end

  def set_activity
    if logged_in?
      current_player.update_column(:updated_at, Time.now)
    end
  end

  def get_cart

    if logged_in?
      if session[:cart].blank?
        session[:total] = 0
        logger.info('[INFO] : Корзина пуста.')
      else
        session[:total] = 0
        @cart= Scumitem.find(session[:cart].keys)

        logger.info('[INFO] : Корзина получена.')
      end


    end
  end

  def index
    @title = 'ГЛАВНАЯ'
    @homepage_topics = Vknews.all.order('created_at desc').limit(6)
    @homepage_topics.blank? ? @noslides = true :  @noslides = false

  end

  def stats
    @title = 'ТОП 20 ИГРОКОВ СЕРВЕРА'
    @activestat = 'active'
    @stats = Playerstat.all.order('player_kills DESC').limit(20)
    @lastedit = Playerstat.all.order('updated_at DESC').first
  end

  def faq
    @activefaq = 'active'
    @faq = Faq.all
  end

  def wiki
    @activewiki = 'active'
  end
  def videos
    @title = 'ИГРОВОЕ ВИДЕО'
    @activevideo = 'active'
@videos = ['2F8xGIMomHM','rXoSmlB-JJc','UZGI_4qGiu0','xSqiIEDP09Y','K19lXMOeG2I','laJT-AeZjjk','-kka0NVEGcs','XKQsc249IiI']
  end

  def events
    @activeevents = 'active'
    @days=['Понедельник','Вторник','Среда','Четверг','Пятница','Суббота','Воскресенье']
    @current_week = []
    week_start = Date.today.beginning_of_week
    i=0
    7.times do
      @current_week.append(week_start+i)
      i = i+1
    end
    e=Event.where(:event_active => true)

    e.each do |ee|
      if ee.event_date.to_date < Date.today
        ee.update_column(:event_active , false)
        ee.update_column(:event_creator , '0')
      end
      if ee.event_date.to_date == Date.today && ee.event_time.to_time < Time.now
        ee.update_column(:event_active , false)
        ee.update_column(:event_creator , '0')
      end
    end
    @events1 = Event.where(:event_date => @current_week[0].strftime('%d/%m/%Y')).order('event_time asc')
    @events2 = Event.where(:event_date => @current_week[1].strftime('%d/%m/%Y')).order('event_time asc')
    @events3 = Event.where(:event_date => @current_week[2].strftime('%d/%m/%Y')).order('event_time asc')
    @events4 = Event.where(:event_date => @current_week[3].strftime('%d/%m/%Y')).order('event_time asc')
    @events5 = Event.where(:event_date => @current_week[4].strftime('%d/%m/%Y')).order('event_time asc')
    @events6= Event.where(:event_date => @current_week[5].strftime('%d/%m/%Y')).order('event_time asc')
    @events7= Event.where(:event_date => @current_week[6].strftime('%d/%m/%Y')).order('event_time asc')
  end

  def event
    @activeevents = 'active'
    @event = Event.find_by_id(params[:event_id])
    if @event
    else
      redirect_to '/'
    end
  end

  def eventapp
    e = Event.find(params[:event_id])
    if e
    if  e.event_players.split(',').include? current_player.id.to_s
      flash[:e_err] = 'Заявка на участие уже подана.'
      redirect_to '/event/'+params[:event_id]
    else
      if e.event_group
        unless e.event_squads.split(',').include? current_player.squad_id.to_s
          e.update_column(:event_squads, e.event_squads.split(',').append(current_player.squad_id.to_s).join(','))
          current_player.update_column(:player_rating , (current_player.player_rating.to_f + 0.02).to_s)
          current_player.squad.update_column(:squad_rating , (current_player.squad.squad_rating.to_f + 0.05).to_s)

        end
        current_player.update_column(:player_rating , (current_player.player_rating.to_f + 0.02).to_s)
        e.update_column(:event_players, e.event_players.split(',').append(current_player.id.to_s).join(','))
      else
        current_player.update_column(:player_rating , (current_player.player_rating.to_f + 0.02).to_s)
        e.update_column(:event_players, e.event_players.split(',').append(current_player.id.to_s).join(','))
      end
      flash[:e_ok] = 'Заявка на участие подана. Просьба быть готовым к мероприятию заранее.'
      redirect_to '/event/'+params[:event_id]
    end
    else
      redirect_to '/'
    end
  end

  def squads
    @activesquads = 'active'
    @squads = Squad.all
  end

end
