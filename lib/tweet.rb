require 'discordrb/webhooks'
require 'net/http'
require 'json'
require 'rubygems'
require 'active_record'
require 'sqlite3'

ActiveRecord::Base.logger = Logger.new(STDERR)


class Vknews < ActiveRecord::Base

end



ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: '..\db\development.sqlite3'
)

WEBHOOK_URL = 'https://discordapp.com/api/webhooks/514046082834235402/6njUGx1IqlA99-_VMsp5CEOzjozQc4yvS88jrpmmipQ2EqJqfpHB7KvoUW1pY738vZ0L'
VK_URL = 'https://api.vk.com/method/wall.get?domain=scum_survival&count=1&access_token=4195381c4195381c4195381c5141f2245f441954195381c1a66deb89cffcc7d165f14b3&v=5.87'
@last_id = 0
@client = Discordrb::Webhooks::Client.new(url: WEBHOOK_URL)
@timer = 3600

if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

def get_and_send
  uri = URI(VK_URL)
  response = Net::HTTP.get(uri)
  parced = JSON.parse(response)
  vk_test = Vknews.find_by_news_id(parced['response']['items'][0]['id'])
  if vk_test
    p 'Нет новых постов...'
    p '---------------------------------------------------------------------'
    return
  else
    p 'Есть новый пост ID : ' + parced['response']['items'][0]['id'].to_s
    vk = Vknews.new
    vk.news_id = parced['response']['items'][0]['id']
    vk.news_image = parced['response']['items'][0]['attachments'].first['photo']['sizes'][6]['url']
    vk.news_name = parced['response']['items'][0]['text'].truncate(40, separator: ' ')
    vk.news_link = 'https://vk.com/scum_survival?w=wall'+ parced['response']['items'][0]['from_id'].to_s + '_' + parced['response']['items'][0]['id'].to_s
    vk.save
    p 'Сообщение записано в БД...'
  #  p 'Подготовка отправки сообщения в дискорд...'
  #  @client.execute do |builder|
  #    builder.content = parced['response']['items'][0]['text']
  #    builder.add_embed do |embed|
  #      embed.image = Discordrb::Webhooks::EmbedImage.new(url: parced['response']['items'][0]['attachments'].first['photo']['sizes'][6]['url'])
  #    end
   end
    p 'Сообщение отправлено...'
    p '---------------------------------------------------------------------'
    @last_id = parced['response']['items'][0]['id'].to_i
  end




loop do
  p '---------------------------------------------------------------------'
  p 'Парсим ВК...'
  get_and_send()
  sleep(@timer)

end





#p parced['response']['items'][0]['id']
#p parced['response']['items'][0]['from_id']
#p parced['response']['items'][0]['text']
#p parced['response']['items'][0]['text'].truncate(40, separator: ' ')
#p  parced['response']['items'][0]['attachments'].first['photo']['sizes'][6]['url']
#p 'https://vk.com/scum_survival?w=wall'+ parced['response']['items'][0]['from_id'].to_s + '_' + parced['response']['items'][0]['id'].to_s





