require 'discordrb'
require 'nokogiri'
require 'open-uri'
require 'rubygems'
require 'active_record'
require 'yaml'
require 'sqlite3'



ActiveRecord::Base.logger = Logger.new(STDERR)


class Event < ActiveRecord::Base
#  serialize :players, JSON
end

class Squad < ActiveRecord::Base

end
class Player < ActiveRecord::Base

end
class Privatemessage < ActiveRecord::Base

end

ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: '..\db\development.sqlite3'
)

bot = Discordrb::Commands::CommandBot.new token: 'NDkyNDIyNzA1OTkyMTcxNTIw.DoWQmg.zVJhZ5TSZU6OuSlTPEs1eIfcp4o', client_id: 492422705992171520, prefix: '!'

bot.command :igc do |event|
  event.user.pm ('**Доступные команды IGC-БОТА**
  ------------------------------
  !server - Информация о игровом сервере и сообществе (количество игроков, ранг, название и IP-адрес, группа ВК и сайт)
  !squads - Информация о отрядах
  !squad - Заявка на вступление в отряд в формате : !squad[пробел]НОМЕР ОТРЯДА (например : !squad 1). **Регистрация на сайте http://www.gamescum.ru обязательна!!!**
  !events - Информация о мероприятиях на сервере (также можно посмотреть тут : http://www.gamescum.ru/events)
  !event - Информация о конкретном мероприятии в формате : !event[пробел]НОМЕР МЕРОПРИЯТИЯ (например : !event 1)
  -----------------
  **GRESHNIK WAS HERE**')
end

bot.command :server do |event|
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
  event << '----------------------------------'
  event << '12 реальных часов - 1 игровой день'
  event << '**Рестарты сервера в: 00:00 и 12:00 МСК**'
  event << '----------------------------------'
  event << '**Группа ВК** : https://vk.com/igcommunity'
  event << '**Сайт** : http://www.gamescum.ru/'
end



bot.command :events do |event|

e= Event.all
e.each do |ee|
  event <<  'Номер :' + ee.number + ' | ' +'Название :' + ee.name + ' | ' + 'Дата и время : '  +  ee.date + '/' + ee.time + ' | ' + 'Участников : '  +  (ee.players.blank? ? '0' : ee.players.keys.count.to_s)

end
return nil
end
bot.command :squads do |event|

  s= Squad.all
  s.each do |ss|
    p = Player.find(ss.squad_leader)
    event <<  'Номер п/п : ' + ss.id.to_s + ' | ' +'Название отряда : ' + ss.squad_name + ' | ' + (ss.squad_recruting ? 'Набор в отряд открыт' : 'Набор в отряд закрыт') + ' | ' +' Лидер отряда : ' +  'http://localhost:3000/profile/'+p.player_nickname_translit

  end
  return nil
end

bot.command :squad do |event,squad_id|
  p = Player.find_by_player_discord_link(event.user.name + '#' +event.user.tag)
  if p.nil?
    event.user.pm ('Похоже ты не зарегистрирован на сайте или при регистрации указал не правильный DISCORD ID')
  else
    if p.squad_id
      s= Squad.find_by_id(squad_id)
      if s.nil?
        event.user.pm ('Нет отряда с таким номером, набери !squads и уточни еще раз номер отряда')
      else
        if s.squad_recruting
          if s.squad_in_request.split(',').include? p.id.to_s
            event.user.pm ('Ты уже подавал заявку на вступление. Свяжись с лидером отряда, чтобы ускорить этот процесс')
          else
            s.update_column(:squad_in_request,s.squad_in_request.split(',').append( p.id.to_s).join(','))
            leader = Player.find(s.squad_leader)
            m= Privatemessage.new
            m.player_id = p.id.to_s
            m.message_for_id = leader.id.to_s
            m.message_text ='Заявка на вступление в отряд от <a href="http://localhost:3000/profile/' + p.player_nickname_translit+'">' + p.player_nickname + '</a>'
            m.save
            event.user.pm ('Заявка подана. Ты получишь личное сообщение на сайте и письмо на почту, как только заявка будет рассмотрена. **Внимание, письма с сайта могут не доходить на почтовые сервисы mail.ru и yandex.ru !!!**')


          end
        else
          event.user.pm ('Отряд не ведет набор новых бойцов в данный момент')
        end


      end
    else
      event.user.pm ('Ты уже состоишь в другом отряде')
    end

  end


  return nil
end

bot.command :ea do |event,eid,steam_nick|

  ee= Event.find(eid)
  if ee.players.blank?
    u={}
    u[event.user.name + '#' +event.user.tag] = steam_nick
    ee.update_column(:players, u)
    event.user.pm ('Ты добавлен на ивент')
  else
    if ee.players.key? (event.user.name + '#' +event.user.tag)
      event.user.pm ('Ты уже добавлен на ивент. ЖДИ! Будешь еще флудить запросами, бот будет кикать!')
    else
      u= ee.players
      u[event.user.name + '#' +event.user.tag] = steam_nick
      ee.update_column(:players, u)
      event.user.pm ('Ты добавлен на ивент')
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

