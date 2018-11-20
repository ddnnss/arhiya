require 'discordrb'

bot = Discordrb::Commands::CommandBot.new token: 'NTExODQ4MzI0MzQxNTYzNDA0.Dsw3qg.hZS4bIbVgWhJs_8q5BzA79klonw', client_id: 511848324341563404, prefix: '!'

bot.command :t76 do |event|
  event.user.pm ('
  ------------**ОБЩИЕ КОМАНДЫ**------------------
  !lfm - поиск игрока в группу. Использование: !lfm сколько_нужно_человек уровень возраст
  !s - Продажа предмета
  !b - Покупка предмета
  !t - Обмен предмета
  -----------------------------------------------
  ' + Base64.decode64('KipHUkVTSE5JSyBXQVMgSEVSRSoq'))
end

bot.command :l do |event,ppl,level,age,*info|
     event.message.delete
     cur_user = event.message.user.id
     cur_server = 485410438436356096    #ID сервера
     post_channel = 499494113385644034  #ID канала, где бот будет писать сообщение
     invite_time = 3600                 #время действия инвайта в сек.
     i = 1
     descr = ''
     if bot.user(cur_user).on(cur_server).voice_channel == nil
       event.user.pm 'Зайди в голосовой канал, в котором собираешь группу.'
     else
       if info.empty?
         infa = 'Не указана'
       else
         infa =  "#{info.join(' ')}"
       end
       event.channel.send_embed(message = '**Нужно ' + ppl.to_s + ' чел. в пати. | ' + 'Уровень от : ' + level.to_s + '. Возраст от : ' + age.to_s + ' | Цель : '  + infa + '**') do |embed|
         embed.author = { name: "Состав группы :"}
         bot.user(cur_user).on(cur_server).voice_channel.users.each do |u|
           descr = descr + i.to_s + ' : ' + '<@' + u.id.to_s + '> '
           i= i+1
         end
         embed.description = descr

       end
       invite = bot.user(cur_user).on(cur_server).voice_channel.invite(invite_time).url
       event.channel.send_message(invite)
     end

end

bot.command :s do |event,item,price|

  if event.message.attachments.empty?
    event.message.delete
    event << 'Игрок ' + event.user.mention + ' хочет продать : ' + item.to_s + ' за ' + price.to_s + ' крышек.'

  else
    event.channel.send_embed(message = 'Продавец ' + event.user.mention) do |embed|
      embed.title = ' Продаю ' + item.to_s + ' за ' + price.to_s + ' крышек.'
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: event.message.attachments[0].url)
    end
    event.message.delete
  end

  return nil
end

bot.command :b do |event,item,price|

  if event.message.attachments.empty?
    event.message.delete
    event << 'Игрок ' + event.user.mention + ' хочет купить : ' + item.to_s + ' за ' + price.to_s + ' крышек.'
  else
    event.channel.send_embed(message = 'Покупатель ' + event.user.mention) do |embed|
      embed.title = ' Куплю ' + item.to_s + ' за ' + price.to_s + ' крышек.'
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: event.message.attachments[0].url)
    end
    event.message.delete
  end

  return nil

end

bot.command :t do |event,item1,item2|

   event << 'Игрок ' + event.user.mention + ' хочет обменять : ' + item1.to_s + ' на ' + item2.to_s + ' .'
   event.message.delete
   return nil
end

bot.run

