# coding: utf-8
module GBPbot
  module Events
    module AutoControl
      require 'thread'
      extend Discordrb::EventContainer

      ch = ["#regular", "#veteran", "#general"]
      h = Hash.new
      
      def self.checkReaction(e, s)
        return (e.emoji.name == s && # emoji is SOS
                !e.message.from_bot? # message from human
               )
      end

      # add empty reaction if be invited
      message(contains: Regexp.new("\\d{5}"), in: ch) do |event|
        sleep(2)
        event.message.create_reaction('🈳')

      end

      # remove empty reaction if add full reaction
      reaction_add(emoji: '🈵') do |event|
          event.message.delete_reaction(BOT.user(320885414582026252), '🈳')
          h.delete(event.message.id)
      end


      #auto SOS
      reaction_add(emoji: '🈳') do |event|
        h.store(event.message.id, true)
        sleep(10)
        if h.key?(event.message.id) && h[event.message.id]
          event.message.create_reaction('🆘')
        end
      end

      reaction_add(emoji: '🆘') do |event|
        h.store(event.message.id, false)
      end
      
    end
  end
end
