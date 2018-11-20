require 'discordrb/webhooks'
require 'net/http'
require 'json'

WEBHOOK_URL = 'https://discordapp.com/api/webhooks/514046082834235402/6njUGx1IqlA99-_VMsp5CEOzjozQc4yvS88jrpmmipQ2EqJqfpHB7KvoUW1pY738vZ0L'
VK_URL = 'https://api.vk.com/method/wall.get?domain=fallout&count=1&access_token=4195381c4195381c4195381c5141f2245f441954195381c1a66deb89cffcc7d165f14b3&v=5.87'
@last_id = 0
@client = Discordrb::Webhooks::Client.new(url: WEBHOOK_URL)
@timer = 1800

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
  if @last_id == parced['response']['items'][0]['id'].to_i
    p 'Нет новых постов...'
    p '---------------------------------------------------------------------'
    return
  else
    p 'Есть новый пост ID : ' + parced['response']['items'][0]['id'].to_s
    p 'Подготовка отправки сообщения в дискорд...'
    @client.execute do |builder|
      builder.content = parced['response']['items'][0]['text']
      builder.add_embed do |embed|
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: parced['response']['items'][0]['attachments'].first['photo']['sizes'][6]['url'])
      end
    end
    p 'Сообщение отправлено...'
    p '---------------------------------------------------------------------'
    @last_id = parced['response']['items'][0]['id'].to_i
  end


end

loop do
  p '---------------------------------------------------------------------'
  p 'Парсим ВК...'
  get_and_send()
  sleep(@timer)

end





# parced['response']['items'][0]['id']
#  parced['response']['items'][0]['text']
#  parced['response']['items'][0]['attachments'].first['photo']['sizes'][6]['url']





