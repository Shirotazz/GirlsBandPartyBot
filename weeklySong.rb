# coding: utf-8
# https://discordapp.com/oauth2/authorize?client_id=320538466632990720&scope=bot&permissions=0

require 'discordrb'
require './token.rb'

$songColumn = 1
$songlist = []
$cheer = ["頑張りましょう。", "えいえいおー！", "フルコンよゆーでしょ♪", "GOGO！", "がんばろ！", "ブシドー！"]
$MAXLVL = "28"

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
  if val.empty? then
    difficulty = "1"
  else
  
  difficulty = val[0].to_i > $MAXLVL.to_i ? $MAXLVL : val[0].to_i
  list = $songlist.select { |id, name, dif| dif.to_i >= difficulty.to_i}
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
