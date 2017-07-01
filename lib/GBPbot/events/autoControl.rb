# coding: utf-8
module GBPbot
  module Events
    module AutoControl
      require 'thread'
      extend Discordrb::EventContainer

      allowedChannel = ["regular", "veteran", "experimental"]
      ignoreChannel = ["botonly", "free"]
      sos = Hash.new
      msg = Hash.new
      
      config = Config.new
      
      def self.checkReaction(e, s)
        return (e.emoji.name == s &&
                !e.message.from_bot? &&
                e.message.channel.name != "botonly"
               )
      end

      # add empty reaction if be invited
      message(contains: Regexp.new("\\d{5}"), in: allowedChannel) do |event|
        event.message.create_reaction('🈳')
      end


      reaction_add do |event|
        case event.emoji.name
        when "🈵"
          # remove empty reaction if add full reaction
          event.message.delete_reaction(BOT.user(config.client_id), "🈳")
          event.message.delete_reaction(BOT.user(config.client_id), "🆘")
          sos.delete(event.message.id)

        when "🈳"
          # send SOS message if room is not full after 180sec
          sos.store(event.message.id, true)
          sleep(10)
          if sos.key?(event.message.id) && sos[event.message.id]
            event.message.create_reaction("🆘")
          end

        when "🆘"
          sos.store(event.message.id, false)
          msg.store(event.message.id, BOT.send_message("#{$tempChannelID}", "#{event.message} :sos: from \##{event.message.channel.name} "))
        end

        
      end

      reaction_remove do |event|
        if checkReaction(event, "🆘") && msg.key?(event.message.id)
          msg.delete(event.message.id).delete
        end
      end

    end
  end
end
