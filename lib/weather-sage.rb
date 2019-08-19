#
# Wrapper around NWS weather.gov and Census bureau geocoder API.
#
module WeatherSage
  #
  # Release version.
  #
  VERSION = '0.1.0'

  # :nodoc:
  LIB_DIR = File.join(__dir__, 'weather-sage').freeze

  autoload :Cache, File.join(LIB_DIR, 'cache.rb')
  autoload :HttpError, File.join(LIB_DIR, 'http-error.rb')
  autoload :HttpCache, File.join(LIB_DIR, 'http-cache.rb')
  autoload :Context, File.join(LIB_DIR, 'context.rb')
  autoload :Census, File.join(LIB_DIR, 'census.rb')
  autoload :Weather, File.join(LIB_DIR, 'weather.rb')
  autoload :CLI, File.join(LIB_DIR, 'cli.rb')
end
