# coding: utf-8
module GBPbot
  module Events
    module SOS
      require 'thread'
      extend Discordrb::EventContainer

      h = Hash.new
      t = Thread.new(h) do |h|
        # watchHash(h)
      end

      def self.watchHash(h)
        while true
          if h.empty? then
            sleep(30)
          else
            k = h.keys
            sleep(120)
            if h.keys == k
              h.each do |k, v|
                v.delete
              end
              h.clear
            end
          end
        end
      end

      def self.checkReaction(e)
        return (e.emoji.name == '🆘' && # emoji is SOS
                !e.message.from_bot? && # message from human
                e.message.channel.name != "botonly" ## message from channel
               )
      end

      reaction_add do |event|
        if checkReaction(event) && !h.key?(event.message.id)
          h.store(event.message.id, BOT.send_message("#{$tempChannelID}", "#{event.message} :sos: from \##{event.message.channel.name} "))
          
        end
      end

      reaction_remove do |event|
        if checkReaction(event) && h.key?(event.message.id)
            h.delete(event.message.id).delete
        end
      end

    end
  end
end

