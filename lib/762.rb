require 'discordrb'

bot = Discordrb::Commands::CommandBot.new token: 'NTExODQ4MzI0MzQxNTYzNDA0.Dsw3qg.hZS4bIbVgWhJs_8q5BzA79klonw', client_id: 511848324341563404, prefix: '!'

bot.command :t76 do |event|
  event.user.pm ('
  ------------**ОБЩИЕ КОМАНДЫ**------------------
  !s - Продажа предмета
  !b - Покупка предмета
  !t - Обмен предмета
  -----------------------------------------------
  **GRESHNIK WAS HERE**')
end

bot.command :lfm do |event,ppl,level,age|
   if event.channel.type == 1
     cur_user = event.message.user.id
     c_id = bot.user(cur_user).on(485410438436356096).voice_channel.id
     descr = ''
     if bot.user(cur_user).on(485410438436356096).voice_channel == nil
       event.user.pm 'Зайди в голосовой канал сначала'
     else


       event.user.pm.send_embed(message = '**ПОИСК ПАТИ**') do |embed|
         embed.author = { name: 'ИЩУ ' + ppl.to_s + ' чел. в пати. | ' + '**ТРЕБОВАНИЯ** Уровень : ' + level.to_s + '. Возраст : ' + age.to_s}

         bot.user(cur_user).on(485410438436356096).voice_channel.users.each do |u|
           descr = descr + '<@' + u.id.to_s + '>'
         end
         embed.description = descr




       end

       invite = bot.user(cur_user).on(485410438436356096).voice_channel.invite.url 
event << invite
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

