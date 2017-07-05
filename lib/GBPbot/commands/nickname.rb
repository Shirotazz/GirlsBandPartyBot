# coding: utf-8
module GBPbot
  module Commands
    module Nickname
      extend Discordrb::Commands::CommandContainer
      command(:nickname, description: "owner only") do |event, name|
        break unless event.user.id == 299039743705088001
        event.server.member(320538466632990720).nick=(name)
      end
    end
  end
end

