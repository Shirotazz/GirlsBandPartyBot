# coding: utf-8
# https://discordapp.com/oauth2/authorize?client_id=320538466632990720&scope=bot&permissions=0
require 'yaml'

module GBPbot

  require 'discordrb'

  # make songlist
  def self.makesonglist
    begin
      File.open("#{File.dirname(__FILE__)}/data/songlist") do |file|
        $songlist = file.each_line.map(&:chomp).map { |line| line.split("\t") }
      end
    rescue
      puts("file does not exist")
    end
  end

  def self.savesonglist
      File.open("#{File.dirname(__FILE__)}/data/songlist", "w") do |file|
        $songlist.each do |id, name, diff|
          file.write("#{id}\t#{name}\t#{diff}\n")
        end
      end
  end

  Dir["#{File.dirname(__FILE__)}/GBPbot/*.rb"].each { |file| require file }

  config = Config.new
  BOT = Discordrb::Commands::CommandBot.new(token: config.token,
                                            client_id: config.client_id,
                                            prefix: config.prefix
                                           )

  # Discord commands
  module Commands; end
  Dir["#{File.dirname(__FILE__)}/GBPbot/commands/*.rb"].each { |mod| require mod }
  Commands.constants.each do |mod|
    BOT.include! Commands.const_get mod
  end
  
  # Discord events
  module Events; end
  Dir["#{File.dirname(__FILE__)}/GBPbot/events/*.rb"].each { |mod| require mod }
  Events.constants.each do |mod|
    BOT.include! Events.const_get mod
  end

  # song list initialize
  makesonglist
  

  BOT.run :async
  BOT.game=("バンドリ！ガールズバンドパーティー！") 

  loop do
    sleep(60)
    GBPbot::savesonglist
  end

end
