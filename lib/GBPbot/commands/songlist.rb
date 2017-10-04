# coding: utf-8
module GBPbot
  module Commands
    module SongList
      extend Discordrb::Commands::CommandContainer
      
      roleWL = BOT.server($serverID).roles.select do |r|        r.name == "white"
      end
      
      command(:songlist,
              description: "mention song list",
              required_roles: roleWL) do |event|

        msg = "%s %-20s %s\n" % ["id", "name", "difficulty"]
        k = 0
        $songlist.each do |song|
          msg << "%2d %-20s %2d\n" % song
          k += 1
          if k == 20
            event.user.pm("#{msg}")
            msg = ""
          end
        end
        event.user.pm("#{msg}")
      end

      command(:songadd,
              description: "add song. need NAME, DIFFICULTY",
              usage: "use space to separater.\n ex. !songadd Scarlet Sky 26",
              required_roles: roleWL) do |event, *val|
        id = $songlist.last[0].to_i + 1
        diff = val.pop
        name = val.join(" ")
        $songlist << ["#{id}","#{name}","#{diff}"]
        puts "add #{id},#{name},#{diff}"
      end

      command(:songedit,
              description: "edit song. need ID, NAME, DIFFICULTY",
              usage: "ex. !songedit 29 LOUDER 27",
              required_roles: roleWL) do |event, id, *val|
        diff = val.pop
        name = val.join(" ")
        $songlist.each do |arr|
          if arr[0].to_i == id
            arr[1] = name
            arr[2] = diff
          end
        end
        puts "edit #{id},#{name},#{diff}"
      end
      
      command(:songrm,
              description: "delete song. need ID",
              usage: "ex. !songrm 34",
              required_roles: roleWL) do |event, id|
        $songlist.delete_if {|arr| arr[0].to_i == id}
        puts "delete #{id}"
      end

    end
  end
end

