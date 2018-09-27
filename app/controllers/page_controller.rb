class PageController < ApplicationController
  require 'discordrb'
  require 'nokogiri'
  require 'open-uri'

  def index
    @title = 'ГЛАВНАЯ'
    @homepage_topics = Topic.where(topic_show_homepage: true ).order('created_at desc').last(6)
    @homepage_topics.blank? ? @noslides = true :  @noslides = false






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







end
