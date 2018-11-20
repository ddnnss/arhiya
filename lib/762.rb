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

bot.command :lfm do |event,ppl,level,age,*info|
   if event.channel.type == 1
     cur_user = event.message.user.id
     cur_server = 485410438436356096    #ID сервера
     post_channel = 499494113385644034  #ID канала, где бот будет писать сообщение
     i = 1
     descr = ''
     if bot.user(cur_user).on(cur_server).voice_channel == nil
       event.user.pm 'Зайди в голосовой канал, в котором собираешь группу.'
     else
       if info.empty?
         infa = 'Не указано'
       else
         infa =  "#{info.join(' ')}"
       end
       bot.channel(post_channel).send_embed(message = 'ИЩУ ' + ppl.to_s + ' чел. в пати. | ' + '**ТРЕБОВАНИЯ** Уровень : ' + level.to_s + '. Возраст : ' + age.to_s + ' | **ДОП. ИНФА : **'  + infa) do |embed|
         embed.author = { name: "Состав группы :"}
         bot.user(cur_user).on(cur_server).voice_channel.users.each do |u|
           descr = descr + i.to_s + ' : ' + '<@' + u.id.to_s + '> '
           i= i+1
         end
         embed.description = descr

       end
       invite = bot.user(cur_user).on(cur_server).voice_channel.invite(3600).url
       bot.send_message(post_channel,invite)
     end
   else
     event.user.pm 'Напиши мне в личку эту команду'
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

