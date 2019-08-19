module WeatherSage
  module CLI
    #
    # Namespace for command-line commands.
    #
    module Commands
      autoload :Command, File.join(__dir__, 'commands', 'command.rb')
      autoload :HelpCommand, File.join(__dir__, 'commands', 'help.rb')
      autoload :GeocodeCommand, File.join(__dir__, 'commands', 'geocode.rb')
      autoload :NowCommand, File.join(__dir__, 'commands', 'now.rb')
      autoload :StationsCommand, File.join(__dir__, 'commands', 'stations.rb')
      autoload :ForecastCommand, File.join(__dir__, 'commands', 'forecast.rb')
      autoload :HourlyCommand, File.join(__dir__, 'commands', 'hourly.rb')
    end
  end
end
