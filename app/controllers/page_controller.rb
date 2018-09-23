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

  def whitelist

  end

  def idcheck
    ww = Whitelist.find_by_player_id(params[:steam_id])
    unless ww.blank?

      if ww.added
        flash[:wh_ок] = 'Этот STEAM ID внеснен в WhiteList сервера. Приятной игры.'
      else
        flash[:wh_error] = 'Этот STEAM ID еще находится на рассмотрении.'
      end

    else
      flash[:wh_error] = 'Этот STEAM ID не найден'
    end
  end

  def dbot



  end

end
