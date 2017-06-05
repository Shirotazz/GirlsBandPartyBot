# coding: utf-8
module GBPbot
  module Commands
    module Kadai
      extend Discordrb::Commands::CommandContainer
      command(:kadai, description: "!kadai / !kadai [difficulty] / !kadai [min] [max] [number of song]") do |event, *val|

        cheer = ["頑張りましょう。", "えいえいおー！", "フルコンよゆーでしょ♪", "GOGO！", "がんばろ！", "ブシドー！"]


        if $songlist.empty?
          event.respond("refresh を実行してください。")
        end

        case val.length
        when 0, 1
          d = val[0].to_i
          min = d > $MAXLVL.to_i ? $MAXLVL : d
          list = $songlist.select { |id, name, dif| min.to_i <= dif.to_i }
          event.respond("課題曲は#{list.sample[$songColumn]}です。 #{cheer.sample}")

        when 2, 3
          if val.length == 3
            c = val.pop.to_i
            count = (0 < c && c <= 10) ? c : 1
          else
            count = 1
          end
          min = val.sort_by(&:to_i)[0]
          max = val.sort_by(&:to_i)[1]
          min = ($MINLVL <= min && min <= $MAXLVL) ? min : $MINLVL
          max = ($MINLVL <= max && max <= $MAXLVL) ? max : $MAXLVL

          if count == 1
            list = $songlist.select { |id, name, dif| (min.to_i <= dif.to_i && dif.to_i <= max.to_i) }
            event.respond("課題曲は#{list.sample[$songColumn]}です。 #{cheer.sample}")
          else
            list = $songlist.select { |id, name, dif| (min.to_i <= dif.to_i && dif.to_i <= max.to_i) }
            list = list.sample(count)
            event << "課題曲は、"
            for i in 1..list.length
              event << "#{i}. #{list[i-1][$songColumn]}"
            end
            event << "です。 #{cheer.sample}"
          end
        end
      end
    end
  end
end

