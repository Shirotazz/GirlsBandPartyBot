# coding: utf-8
module GBPbot
  module Commands
    module Refresh
      extend Discordrb::Commands::CommandContainer
      command(:refresh, description: "refresh song list") do |event|
        $songlist.clear
        GBPbot::makesonglist
        event.respond('楽曲リストを更新しました。')
      end
    end
  end
end

