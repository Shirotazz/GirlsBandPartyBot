# coding: utf-8
# https://discordapp.com/oauth2/authorize?client_id=320538466632990720&scope=bot&permissions=0

require 'discordrb'
require '.token.rb'

$songColumn = 1
$songlist = []
$cheer = ["頑張りましょう。", "えいえいおー！", "フルコンよゆーでしょ♪", "GOGO！", "がんばろ！", "ブシドー！"]
$MAXLVL = "28"
$MINLVL = "1"
$freeChannelID = "299048531946242050"

begin
  File.open('songlist') do |file|
    $songlist = file.each_line.map(&:chomp).map { |line| line.split("\t") }
  end
rescue
  puts("file does not exist")
end

bot.command(:kadai, description: "!kadai [difficulty]") do |event, *val|
  if $songlist.empty?
    event.respond("refresh を実行してください。")
  end
  
  # difficulty check
  case val.length
  when 0, 1
    d = val[0].to_i
    min = d > $MAXLVL.to_i ? $MAXLVL : d
    list = $songlist.select { |id, name, dif| min.to_i <= dif.to_i }
    event.respond("課題曲は#{list.sample[$songColumn]}です。 #{$cheer.sample}")

  when 2, 3
    if val.length == 3
      c = val.pop.to_i
      count = (0 < c && c < 10) ? c : 1
    else
      count = 1
    end
    min = val.sort_by(&:to_i)[0]
    max = val.sort_by(&:to_i)[1]
    min = ($MINLVL < min && min < $MAXLVL) ? min : $MINLVL
    max = ($MINLVL < max && max < $MAXLVL) ? max : $MAXLVL

    if count == 1
      list = $songlist.select { |id, name, dif| (min.to_i <= dif.to_i && dif.to_i <= max.to_i) }
      event.respond("課題曲は#{list.sample[$songColumn]}です。 #{$cheer.sample}")
    else
      event << "課題曲は、"
      for i in 1..count
        list = $songlist.select { |id, name, dif| (min.to_i <= dif.to_i && dif.to_i <= max.to_i) }
        event << "#{i}. #{list.sample[$songColumn]}"
      end
      event << "です。 #{$cheer.sample}"
    end
  end
end

bot.command(:makeroom, min_args: 2, max_args: 3, description: "!makeroom [roomID] [difficulty] [message]") do |event, roomID, difficulty, message|
  if $songlist.empty?
    event.respond("refresh を実行してください。")
  end
  
  #roomID check
  if ( roomID.to_i < 0 && 99999 < roomID.to_i )
    event.respond("invalid room ID")
    break
  end

  # difficulty check
  if ( difficulty.to_i < $MINLVL.to_i || $MAXLVL.to_i < difficulty.to_i )
    difficulty = 1
  end

  #memo check
  if message.length > 30
    event.respond("message exceeds 30 characters.")
    break
  end

  list = $songlist.select { |id, name, dif| difficulty.to_i <= dif.to_i }
  bot.send_message("#{$freeChannelID}", "#{roomID} #{list.sample[$songColumn]} #{message}")
end


bot.command(:refresh, description: "refresh song list") do |event|
  $songlist.clear
  File.open('songlist') do |file|
    $songlist = file.each_line.map(&:chomp).map { |line| line.split("\t") }
  end
  event.respond('楽曲リストを更新しました。')
end

bot.run
