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


      bot = Discordrb::Commands::CommandBot.new token: 'NDkyNDIyNzA1OTkyMTcxNTIw.DoWQmg.zVJhZ5TSZU6OuSlTPEs1eIfcp4o', client_id: 492422705992171520, prefix: '!'

      bot.command :help do |event|
        event << '**Управление IGC ботом**'
        event << '!ss - Информация о игровом сервере (количество игроков, ранг, название и IP-адрес)'
        event << '!ii - Информация о сообществе (группа ВК, сайт ...)'
        event << '!sr - Информация о рестартах'
        event << '!se - Информация о мероприятиях на сервере'
      end

      bot.command :ss do |event|
          url = 'https://www.battlemetrics.com/servers/scum/2648150'
          html = open(url)
          doc = Nokogiri::HTML(html)
          players = doc.xpath('//*[@id="serverPage"]/div[1]/div/dl/dd[2]').text
          rank = doc.xpath('//*[@id="serverPage"]/div[1]/div/dl/dd[1]').text
          name = doc.xpath('//*[@id="serverPage"]/div[1]/div/dl/dd[1]').text
          ip = doc.xpath('//*[@id="serverPage"]/div[1]/div/dl/dd[1]').text
          event << '**Название сервера** : ' + name.to_s
          event << '**Ранг сервера** : ' + rank.to_s
          event << '**Игроков** : ' + players.to_s
          event << '**IP сервера** : ' + ip.to_s


      end

    bot.run


  end

end
