require 'discordrb'
require 'nokogiri'
require 'open-uri'






bot = Discordrb::Bot.new token: 'NDkyNDIyNzA1OTkyMTcxNTIw.DoWQmg.zVJhZ5TSZU6OuSlTPEs1eIfcp4o'

bot.message(with_text: '!сервер') do |event|
  url = 'https://www.battlemetrics.com/servers/scum/2648150'
  html = open(url)
  doc = Nokogiri::HTML(html)
  players = doc.xpath('//*[@id="serverPage"]/div[1]/div/dl/dd[2]').text
  rank = doc.xpath('//*[@id="serverPage"]/div[1]/div/dl/dd[1]').text
  event.respond 'Ранг сервера : ' + rank.to_s
  event.respond 'Игроков : ' + players.to_s

end

bot.run