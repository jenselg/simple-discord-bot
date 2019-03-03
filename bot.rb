require 'discordrb'
require 'rubygems'
require 'nokogiri'
require 'open-uri'

@discord_token = ''
@client_id = ''

bot = Discordrb::Commands::CommandBot.new token: @discord_token, client_id: @client_id, prefix: '!'

# Youtube Search
bot.command :yt do |event, *words|
  combined_term = ""
  words.each do |word|
    combined_term += word.to_s
    if word != words.last
      combined_term += " "
    end
  end
  event.respond "**Youtube search for:** #{combined_term}"
  sleep 1
  youtube = Nokogiri::HTML(open("https://www.youtube.com/results?search_query=#{combined_term}"))
  event.respond "https://youtube.com#{youtube.css('.yt-lockup-title .spf-link')[0]['href']}"
end

# Don't Starve Together Search
bot.command :dst do |event, *words|
  combined_term = ""
  words.each do |word|
    combined_term += word.to_s
    if word != words.last
      combined_term += " "
    end
  end
  event.respond "**Don't Starve Together wiki search for:** #{combined_term}"
  sleep 1
  dstwiki = Nokogiri::HTML(open("http://dontstarve.wikia.com/wiki/Special:Search?search=#{combined_term}&fulltext=Search"))
  "#{dstwiki.css('.result-link')[0]['href']}"
end

# MineCraft Search
bot.command :mc do |event, *words|
  combined_term = ""
  words.each do |word|
    combined_term += word.to_s
    if word != words.last
      combined_term += " "
    end
  end
  event.respond "**MineCraft wiki search for:** #{combined_term}"
  sleep 1
  minecraft = Nokogiri::HTML(open("http://minecraft.wikia.com/wiki/Special:Search?query=#{combined_term}"))
  "#{minecraft.css('.result-link')[0]['href']}"
end

# Utility commands
bot.command :temp do |event, temperature, unit|
  case unit.upcase
    when "C"
      "#{temperature}°C in Fahrenheit: #{(((temperature.to_i)*1.8)+32).round(2)}°F"
    when "F"
      "#{temperature}°F in Celsius: #{(((temperature.to_i)-32)*(0.5556)).round(2)}°C"
    else
      "Please type the syntax correctly, i.e. !temp 32 C"
  end
end

bot.command :annoy do |event, count, user, *message|
  full_message = message.join(' ')
  event.respond "Now going to annoy #{user} #{count} time(s) hourly, with the message: #{full_message}"
  count.to_i.times do
    event.respond "Yo #{user}, #{full_message}"
    sleep 3600
  end
end

bot.command :delay do |event, minute, user, *message|
  delayed_message = message.join(' ')
  delayed_minute = minute.to_i * 60
  event.respond "Your message will be re-sent to #{user} after #{delayed_minute/60} minute(s)."
  sleep delayed_minute
  event.respond "#{event.user.name}: #{delayed_message}"
end

bot.run
