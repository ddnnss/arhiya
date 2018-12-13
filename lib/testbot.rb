require 'discordrb'
require 'nokogiri'
require 'open-uri'
require 'rubygems'
require 'active_record'
require 'yaml'
require 'sqlite3'
require 'translit'



ActiveRecord::Base.logger = Logger.new(STDERR)


class Event < ActiveRecord::Base
#  serialize :players, JSON
end

class Squad < ActiveRecord::Base
  has_many :players
end
class Player < ActiveRecord::Base
  belongs_to :squad
end
class Privatemessage < ActiveRecord::Base

end

ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: '..\db\development.sqlite3'
)

bot = Discordrb::Commands::CommandBot.new token: 'NDkyNDIyNzA1OTkyMTcxNTIw.DqEkwg.QzeBPEr6BeAruMPy35tikSAmAxc', client_id: 492422705992171520, prefix: '!'

@next_v = Time.now - 1.month
@last_v_player = ''


bot.command :red do |event|
  event.user.pm ('
  ------------**ОБЩИЕ КОМАНДЫ**------------------
  !p - Информация о количестве игроков на сервере в данный момент
  !server - Информация о игровом сервере и сообществе (количество игроков, ранг, название и IP-адрес, группа ВК и сайт)
  !squads - Информация о отрядах
  !squad - Заявка на вступление в отряд в формате : !squad[пробел]НОМЕР ОТРЯДА (например : !squad 1). **Регистрация на сайте http://www.gamescum.ru обязательна!!!** (также можно посмотреть тут : http://www.gamescum.ru/squads)
  !events - Информация о мероприятиях на сервере (также можно посмотреть тут : http://www.gamescum.ru/events)
  !event - Запись на мероприятии в формате : !event[пробел]НОМЕР МЕРОПРИЯТИЯ (например : !event 1)
  ------------**СПЕЦИАЛЬНЫЕ КОМАНДЫ**------------------
  !reg - регистрация на сайте. Формат команды !reg[пробел]ИГРОВОЙ-НИК[пробел]STEAMID64[пробел]E-MAIL (например: !reg GRESHNIK 76561198091XXXXXX admin@gamescum.ru) УЗНАТЬ СВОЙ STEAMID64 МОЖНО ТУТ https://steamid.xyz
  !zp - ежедневная выплата виртуальной валюты (Для получения нужно быть зереганым на сайте не менее 3х дней)
  !lfm - поиск людей в пати. Формат команды !lfm[пробел]сколько людей ищем(число)[пробел]требуемый возраст(число)[пробел]дополнительная информация (по желанию) (например: !lfm 2 30)
  -----------------------------------
  Бот обновлен : **21.11.2018**
  -----------------------------------
  ** <@387895658826170368> WAS HERE**')
end

bot.command :lfm do |event,ppl,age,*info|
  if event.channel.type == 1
    cur_user = event.message.user.id
    cur_server = 484067040307576873    #ID сервера
    post_channel = 514673082544291840  #ID канала, где бот будет писать сообщение
    invite_time = 3600                 #время действия инвайта в сек.
    i = 1
    descr = ''
    if bot.user(cur_user).on(cur_server).voice_channel == nil
      event.user.pm 'Зайди в голосовой канал, в котором собираешь группу.'
    else
      if info.empty?
        infa = 'Не указаны'
      else
        infa =  "#{info.join(' ')}"
      end
      bot.channel(post_channel).send_embed(message = '**Нужно ' + ppl.to_s + ' чел. в пати. | ' +  '. Возраст от : ' + age.to_s + ' | Цели : '  + infa + '**') do |embed|
        embed.author = { name: "Состав группы :"}
        bot.user(cur_user).on(cur_server).voice_channel.users.each do |u|
          descr = descr + i.to_s + ' : ' + '<@' + u.id.to_s + '> '
          i= i+1
        end
        embed.description = descr

      end
      invite = bot.user(cur_user).on(cur_server).voice_channel.invite(invite_time).url
      bot.send_message(post_channel,invite)
    end
  else
    event.user.pm 'Напиши мне в личку эту команду'
  end
end

bot.command :server do |event|
  url = 'https://www.battlemetrics.com/servers/scum/2966477'
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
  event << '3 реальных часа - 1 игровой день'
  event << '**Рестарты сервера в: 02:30 и 14:30 МСК**'
  event << '----------------------------------'
  event << '**Группа ВК** : https://vk.com/scum_lasthero'
  event << '**Сайт** : http://www.gamescum.ru/'
end

bot.command :p do |event|
  url = 'https://www.battlemetrics.com/servers/scum/2966477'
  html = open(url)
  doc = Nokogiri::HTML(html)
  players = doc.xpath('//*[@id="serverPage"]/div[1]/div/dl/dd[2]').text

  event << '**Игроков ** : ' + players.to_s
  event << '**Рестарты сервера в: 02:30 и 14:30 МСК**'
end



bot.command :events do |event|

e= Event.where(:event_active => true).order('event_date ASC')
unless e.blank?
e.each do |ee|
  event <<  'Номер :' + ee.event_creator + ' | ' +'Название :' + ee.event_name + ' | ' + 'Дата и время : '  +  ee.event_date + ' в ' + ee.event_time + ' | ' + (ee.event_group ? '**МОГУТ УЧАСТВОВАТЬ ТОЛЬКО ОТРЯДЫ**' : '**МОГУТ УЧАСТВОВАТЬ ВСЕ ЖЕЛАЮЩИЕ**') + ' | ' + 'Подробная информация : http://www.gamescum.ru/event/' + ee.id.to_s
end
else
  event <<  'Запланированных мероприятий пока нет.'
  end
return nil
end

bot.command :squads do |event|
  s= Squad.all
  event << 'Зарегистрированные отряды:'
  s.each do |ss|

       event << 'Номер п/п : ' + ss.squad_number.to_s + ' | ' +'Название отряда : ' + ss.squad_name +  ' | ' + (ss.squad_recruting ? 'Набор в отряд открыт' : 'Набор в отряд закрыт')
  end
  return nil
end

bot.command :squad do |event,squad_id|
  p = Player.find_by_player_discord_link(event.user.name + '#' +event.user.tag)
  if p.nil?
    event.user.pm ('Похоже ты не зарегистрирован на сайте или при регистрации указал не правильный DISCORD ID')
  else
    unless p.squad_id
      s= Squad.find_by_squad_number(squad_id)
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
            m.message_text ='Заявка на вступление в отряд от <a href="http://www.gamescum.ru/profile/' + p.player_nickname_translit+'">' + p.player_nickname + '</a>'
            m.save
            event.user.pm ('Заявка подана. Ты получишь личное сообщение на сайте и письмо на почту, как только заявка будет рассмотрена. **Внимание, письма с сайта могут не доходить на почтовые сервисы mail.ru и yandex.ru !!!**')
          end
        else
          event.user.pm ('Отряд не ведет набор новых бойцов в данный момент')
        end
      end
    else
      event.user.pm ('Ты уже состоишь в отряде')
    end
  end
  return nil
end

bot.command :event do |event,event_id|
  e = Event.find_by_event_creator(event_id)
  if e
    p = Player.find_by_player_discord_link(event.user.name + '#' +event.user.tag)
    if p.nil?
      event.user.pm ('Похоже ты не зарегистрирован на сайте или при регистрации указал не правильный DISCORD ID')
    else
      if e.event_players.split(',').include? p.id.to_s
        event.user.pm ('Ты уже записан')
      else
        if e.event_group
          if p.squad_id
            unless e.event_squads.split(',').include? p.squad_id.to_s
              e.update_column(:event_squads, e.event_squads.split(',').append(p.squad_id.to_s).join(','))
              p.update_column(:player_rating , (p.player_rating.to_f + 0.02).to_s)
              p.squad.update_column(:squad_rating , (p.squad.squad_rating.to_f + 0.05).to_s)

            end
            p.update_column(:player_rating , (p.player_rating.to_f + 0.02).to_s)
            e.update_column(:event_players, e.event_players.split(',').append(p.id.to_s).join(','))
            event.user.pm ('Ты и твой отряд записан (**не игроки в отряде, а просто отряд!**)')
          else
            event.user.pm ('Данное мероприятие только для отрядов')
          end
        else
          e.update_column(:event_players, e.event_players.split(',').append(p.id.to_s).join(','))
          p.update_column(:player_rating , (p.player_rating.to_f + 0.02).to_s)
          event.user.pm ('Ты записан')
        end
      end
    end
  else
    event.user.pm ('Нет такого мероприятия. Набери !events')
  end

  return nil
end




bot.command :reg do |event,nick,steamid,mail|
  p = Player.find_by_player_discord_link(event.user.name + '#' +event.user.tag)
  if p.nil?
    pn = Player.new
    if steamid.length != 17
      event.user.pm ('Похоже ты не правильно ввел STEAMID. Уточни на сайте https://steamid.xyz')
    else
      pn.player_nickname  = nick
      pn.player_email = mail
      pn.player_id = steamid
      pn.player_discord_link = event.user.name + '#' +event.user.tag
      pn.player_nickname_translit = Translit.convert(nick.gsub(' ','-').gsub(/[?!*.,:; ]/, ''), :english)
      pn.player_password = [*('a'..'z'),*('0'..'9')].shuffle[0,8].join
      pn.player_activated = true
      pn.player_last_v = Time.now - 1.day
      pn.player_lastlogin = Date.today
      pn.player_last_zp = Time.now - 1.day
      pn.player_rating = '1'
      pn.save
      event.user.pm 'Ты зарегистрирован на сайте http://www.gamescum.ru'
      event.user.pm 'Твой логин : ' + mail
      event.user.pm 'Твой пароль : ' + pn.player_password
    end


  else
    event.user.pm ('Похоже ты уже зарегистрирован на сайте')
  end

end

bot.command :zp do |event|
  p = Player.find_by_player_discord_link(event.user.name + '#' +event.user.tag)
  if p.nil?
    event.user.pm ('Похоже ты не зарегистрирован на сайте или при регистрации указал не правильный DISCORD ID')
  else
    if p.created_at + 3.day < Time.now
      if p.player_last_zp < Time.now
        p.update_column(:player_rating,p.player_rating.to_f + 0.00001)
        p.update_column(:player_last_zp, Time.now + 1.day)
        if p.player_temp2 == 'vip'
          p.update_column(:player_wallet, p.player_wallet + (60 * p.player_rating.to_f).to_i)

          event.user.pm ('Ежедневная выплата выдана. С учетом твоего рейтинга и статуса начислено : ' + (60 * p.player_rating.to_f).to_i.to_s + ' RC . **Текущий баланс** : ' + p.player_wallet.to_s + ' RC')

        else
          p.update_column(:player_wallet, p.player_wallet + (30 * p.player_rating.to_f).to_i)

          event.user.pm ('Ежедневная выплата выдана. С учетом твоего рейтинга и статуса начислено : ' + (30 * p.player_rating.to_f).to_i.to_s + ' RC . **Текущий баланс** : ' + p.player_wallet.to_s + ' RC')

        end


      else
        event.user.pm ('Лимит выполнения команды 1 раз в сутки! **Текущий баланс** : ' + p.player_wallet.to_s + ' RC')
      end
    else
      event.user.pm ('Ежедневная выплата выдается после 3х дней после регистрации на сайте')
    end



  end
  return nil
end



bot.run

#bot.bucket :vend, limit: 1, time_span: 60*60*24, delay: 3600
#bot.command(:V,bucket: :vend, rate_limit_message: 'Команда может выполняться 1 раз в сутки %time% %delay%') do |event,victim|
#  bot.send_message(491290689846378506,'**ВНИМАНИЕ !!!**
#  Игрок ' + event.user.mention + ' объявляет месть игроку с ником ' + victim)
#  bot.send_file(491290689846378506,File.open('c:/vendetta.png', 'r'))
#  return nil
#end


#Z975376717386 R202493688161 https://www.paypal.me/gamescum https://qiwi.me/gamescum https://money.yandex.ru/to/410016706719303