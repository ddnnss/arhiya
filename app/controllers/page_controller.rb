class PageController < ApplicationController
  require 'discordrb'
  require 'nokogiri'
  require 'open-uri'

  def index
    @title = 'ГЛАВНАЯ'


    @homepage_topics = Topic.where(topic_show_homepage: true ).order('created_at desc').last(6)
    @homepage_topics.blank? ? @noslides = true :  @noslides = false






  end
  def launcher
    @p = Player.all

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
