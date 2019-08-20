#
# Namespace for command-line commands.
#
module WeatherSage::CLI::Commands
  LIB_DIR = File.join(__dir__, 'commands') # :nodoc:

  autoload :Command, File.join(LIB_DIR, 'command.rb')
  autoload :HelpCommand, File.join(LIB_DIR, 'help.rb')
  autoload :GeocodeCommand, File.join(LIB_DIR, 'geocode.rb')
  autoload :NowCommand, File.join(LIB_DIR, 'now.rb')
  autoload :StationsCommand, File.join(LIB_DIR, 'stations.rb')
  autoload :BaseForecastCommand, File.join(LIB_DIR, 'base-forecast.rb')
  autoload :ForecastCommand, File.join(LIB_DIR, 'forecast.rb')
  autoload :HourlyCommand, File.join(LIB_DIR, 'hourly.rb')
end
