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







bot.command :s do |event,item,price|

  event.message.delete
  event << 'Игрок ' + event.user.mention + ' хочет продать : ' + item.to_s + ' за ' + price.to_s + ' крышек.'



  return nil
end

bot.command :b do |event,item,price|
  event.message.delete
  event << 'Игрок ' + event.user.mention + ' хочет купить : ' + item.to_s + ' за ' + price.to_s + ' крышек.'

  return nil
end

bot.command :t do |event,item1,item2|
  event.message.delete
  event << 'Игрок ' + event.user.mention + ' хочет обменять : ' + item1.to_s + ' на ' + item1.to_s + ' .'

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