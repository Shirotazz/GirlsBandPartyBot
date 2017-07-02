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
      message(contains: Regexp.new("\\d{5}\\s"), in: allowedChannel) do |event|
        event.message.create_reaction('🈳')
      end


      reaction_add do |event|
        config = Config.new
        if checkReaction(event, "🈵")
          # remove empty reaction if add full reaction
          event.message.delete_reaction(BOT.user(config.client_id), "🈳")
          event.message.delete_reaction(BOT.user(config.client_id), "🆘")
          #event.message.delete_reaction(event.message.author.id, "🈳")
          sos.delete(event.message.id)

        elsif checkReaction(event, "🈳")
          # send SOS message if room is not full after 180sec
          sos.store(event.message.id, true)
          sleep(180)
          if sos.key?(event.message.id) && sos[event.message.id]
            event.message.create_reaction("🆘")
          end

        elsif checkReaction(event, "🆘")
          sos.store(event.message.id, false)

          # msg create
          user = event.message.author.nick.nil? ? "#{event.message.author.username}" : "#{event.message.author.nick}"
          icon = event.message.author.avatar_url
          title = "SOS from #{event.message.channel.name}"
          text = "#{event.message}"
          m = BOT.channel($talkChannelID).send_embed do | embed |
            embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: user,
                                                                icon_url: icon
                                                               )
            embed.add_field(name: title,
                            value: text
                           )
            embed.colour = 16724736
            embed.timestamp = Time.now
          end
          msg.store(event.message.id, m)
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
