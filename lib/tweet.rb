require 'discordrb/webhooks'
require 'net/http'
require 'json'

if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

WEBHOOK_URL = 'https://discordapp.com/api/webhooks/514046082834235402/6njUGx1IqlA99-_VMsp5CEOzjozQc4yvS88jrpmmipQ2EqJqfpHB7KvoUW1pY738vZ0L'
client = Discordrb::Webhooks::Client.new(url: WEBHOOK_URL)



url = 'https://api.vk.com/method/wall.get?domain=fallout&count=1&access_token=4195381c4195381c4195381c5141f2245f441954195381c1a66deb89cffcc7d165f14b3&v=5.87'
uri = URI(url)
response = Net::HTTP.get(uri)
parced = JSON.parse(response)

p  parced['response']['items'][0]['id']
p  parced['response']['items'][0]['text']
p  parced['response']['items'][0]['attachments'].first['photo']['sizes'][6]['url']



client.execute do |builder|
  builder.content = parced['response']['items'][0]['text']
  builder.add_embed do |embed|
  #  embed.title = 'Embed title'
  #  embed.description = 'Embed description'
    embed.image = Discordrb::Webhooks::EmbedImage.new(url: parced['response']['items'][0]['attachments'].first['photo']['sizes'][6]['url'])
  #  embed.timestamp = Time.now
  end
end


