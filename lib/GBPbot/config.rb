# coding: utf-8

module GBPbot

  #global
  $MAXLVL = "28"
  $MINLVL = "1"
  $freeChannelID = "299048531946242050"
  $talkChannelID = "304634866866061332"
  $tempChannelID = "320904750466072577"
  $songColumn = 1
  $songlist = []

  class Config
    def initialize
      @file = "#{Dir.pwd}/data/config.yml"
      temp = loadfile(@file)
      @config = temp if temp.is_a?(Hash) && !temp.empty?
      setup_config if @config.nil?
      create_methods
    end

    private

    def setup_config
      @config = {}

      puts 'There is no config file, running the setup'
      puts 'Enter your discord token '
      @config[:token] = gets.chomp

      puts 'Enter your discord client/application ID'
      @config[:client_id] = gets.chomp

      puts 'Enter your prefix. Press enter for default ("!")'
      @config[:prefix] = gets.chomp
      @config[:prefix] = '!' if @config[:prefix].empty?
      savefile(@file, @config)
    end

    def create_methods
      @config.keys.each do |key|
        self.class.send(:define_method, key) do
          @config[key]
        end
      end
    end

    def savefile(file, object)
      File.open(file, 'w') do |f|
        f.write YAML.dump(object)
      end
    end

    def loadfile(file)
      return YAML.load_file(file) if File.exist?(file)
      {}
    end
  end
end
