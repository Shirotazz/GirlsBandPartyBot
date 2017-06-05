# coding: utf-8
module GBPbot
  module Events
    module SOS
      require 'thread'
      extend Discordrb::EventContainer

      q = Queue.new
      
      reaction_add do |event|
        if event.emoji.name == '🆘'
          q.push(BOT.send_message("#{$talkChannelID}", "#{event.message} :sos: from \##{event.message.channel.name}"))
        end
      end

      reaction_remove do |event|
        if event.emoji.name == '🆘'
          q.pop.delete
        end
      end
      
    end
  end
end

