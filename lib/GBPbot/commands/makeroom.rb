# coding: utf-8
module GBPbot
  module Commands
    module Makeroom
      extend Discordrb::Commands::CommandContainer
      command(:makeroom, min_args: 2, description: "!makeroom [roomID] [difficulty] [message]") do |event, roomID, difficulty, *message|
        if $songlist.empty?
          event.respond("refresh を実行してください。")
        end
        
        #roomID check
        if ( roomID.to_i < 0 || 99999 < roomID.to_i )
          event.respond("invalid room ID")
          break
        end

        # difficulty check
        if ( difficulty.to_i < $MINLVL.to_i || $MAXLVL.to_i < difficulty.to_i )
          difficulty = 1
        end

        #message check
        len = 0
        str = ""
        for i in 0..message.length-1
          len += message[i].length
          str << " " << message[i]
        end
        if len > 30
          event.respond("message exceeds 30 characters.")
          break
        end

        list = $songlist.select { |id, name, dif| difficulty.to_i <= dif.to_i }
        BOT.send_message("#{$freeChannelID}", "#{roomID} #{list.sample[$songColumn]}#{str}")
      end

    end
  end
end
