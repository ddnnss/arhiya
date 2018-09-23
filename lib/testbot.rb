require 'discordrb'
require 'nokogiri'
require 'open-uri'
require 'rubygems'
require 'active_record'
require 'yaml'
require 'sqlite3'



ActiveRecord::Base.logger = Logger.new(STDERR)


class Event < ActiveRecord::Base
  serialize :players, JSON
end
ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: 'C:\Users\ххх\RubymineProjects\arhiya\db\development.sqlite3'
)

bot = Discordrb::Commands::CommandBot.new token: 'NDkyNDIyNzA1OTkyMTcxNTIw.DoWQmg.zVJhZ5TSZU6OuSlTPEs1eIfcp4o', client_id: 492422705992171520, prefix: '!'

bot.command :hh do |event|
  event << '**Доступные команды**'
  event << '!ss - Информация о игровом сервере (количество игроков, ранг, название и IP-адрес)'
  event << '!ii - Информация о сообществе (группа ВК, сайт ...)'
  event << '!sr - Информация о рестартах'
  event << '!se - Информация о мероприятиях на сервере'
  event << '!ei - Информация о конкретном мероприятии в формате : !ei[пробел]НОМЕР МЕРОПРИЯТИЯ (например : !ei 1)'
  event << '!e - Запись на мероприятие в формате : !e[пробел]НОМЕР МЕРОПРИЯТИЯ[пробел]НИК В ИГРЕ (например : !e 1 GRESHNIK)'
end

bot.command :ss do |event|
  url = 'https://www.battlemetrics.com/servers/scum/2648150'
  html = open(url)
  doc = Nokogiri::HTML(html)
  players = doc.xpath('//*[@id="serverPage"]/div[1]/div/dl/dd[2]').text
  rank = doc.xpath('//*[@id="serverPage"]/div[1]/div/dl/dd[1]').text
  name = doc.xpath('//*[@id="serverPage"]/h2').text
  ip = doc.xpath('//*[@id="serverPage"]/div[1]/div/dl/dd[3]').text
  event << '**Название сервера** : ' + name.to_s[0..-20]
  event << '**Ранг сервера** : ' + rank.to_s
  event << '**Игроков** : ' + players.to_s
  event << '**IP сервера** : ' + ip.to_s
end

bot.command :ii do |event|
  event << '**Группа ВК** : https://vk.com/igcommunity'
  event << '**Сайт** : http://www.gamescum.ru/'

end
bot.command :sr do |event|
  event << '12 реальных часов - 1 игровой день'
  event << 'Расписание рестартов: 00:00 и 12:00'
end
bot.command :se do |event|

e= Event.all
e.each do |ee|
  event <<  'Номер :' + ee.number + ' | ' +'Название :' + ee.name + ' | ' + 'Дата и время : '  +  ee.date + '/' + ee.time + ' | ' + 'Участников : '  +  ee.players.keys.count.to_s

end
return nil
end

bot.command :e do |event,eid,steam_nick|

  ee= Event.find(eid)
  if ee.players.blank?
    u={}
    u[event.user.name + '#' +event.user.tag] = steam_nick
    ee.update_column(:players, u)
    event << 'Ты добавлен на ивент'
  else
    if ee.players.key? (event.user.name + '#' +event.user.tag)
      event << 'Ты уже добавлен на ивент. ЖДИ! Будешь еще флудить запросами, бот будет кикать!'
    else
      u= ee.players
      u[event.user.name + '#' +event.user.tag] = steam_nick
      ee.update_column(:players, u)
      event << 'Ты добавлен на ивент'
    end
  end


  return nil
end

bot.command :ei do |event,eid|

  ee= Event.find(eid)

  event << '**Название мероприятия** :' + ee.name
  event << '**Дата и время проведения** : '  +  ee.date + '/' + ee.time
  event << '**Описание мероприятия** :' + ee.info
  event << '**Участники мероприятия**'

  ee.players.each do |k,v|
    event << '**Дискорд** :'+ event.user.mention  + ' | ' +  '**Ник в игре** :'+ v
  end


  return nil
end




bot.run

