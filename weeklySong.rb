# coding: utf-8
# https://discordapp.com/oauth2/authorize?client_id=320538466632990720&scope=bot&permissions=0

require 'discordrb'
require './token.rb'

$songColumn = 1
$songlist = []
$cheer = ["頑張りましょう。", "えいえいおー！", "フルコンよゆーでしょ♪", "GOGO！", "がんばろ！", "ブシドー！"]
$MAXLVL = "28"
$MINLVL = "1"


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

  difficulty = 1
  count = 1

  # difficulty check
  case val.length
  when 1
    d = val[0].to_i
    difficulty = d > $MAXLVL.to_i ? $MAXLVL : d
  when 2, 3
    if val.length == 3
      c = val.pop.to_i
      count = (0 < c && c < 10) ? c : 1
    end
    min = val.sort_by(&:to_i)[0]
    max = val.sort_by(&:to_i)[1]
    min = ($MINLVL < min && min < $MAXLVL) ? min : $MINLVL
    max = ($MINLVL < max && max < $MAXLVL) ? max : $MAXLVL
  end
    
  list = $songlist.select { |id, name, dif| (min <= dif.to_i && dif.to_i <= max) }
  event.respond("課題曲は#{list.sample[$songColumn]}です。 #{$cheer.sample}")
end

bot.command(:refresh, description: "refresh song list") do |event|
  $songlist.clear
  File.open('songlist') do |file|
    $songlist = file.each_line.map(&:chomp).map { |line| line.split("\t") }
  end
  event.respond('楽曲リストを更新しました。')
end

bot.run
