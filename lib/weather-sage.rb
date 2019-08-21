#
# Get weather forecast and current weather for address.
#
# Wrapper around the following APIs:
#
# * National Weather Service Weather API (https://api.weather.gov/)
# * Census Bureau Geocoder API (https://geocoding.geo.census.gov/geocoder/)
#
module WeatherSage
  #
  # Release version.
  #
  VERSION = '0.1.1'

  # :nodoc:
  LIB_DIR = File.join(__dir__, 'weather-sage').freeze

  autoload :CacheEntry, File.join(LIB_DIR, 'cache-entry.rb')
  autoload :Cache, File.join(LIB_DIR, 'cache.rb')
  autoload :HTTP, File.join(LIB_DIR, 'http.rb')
  autoload :Context, File.join(LIB_DIR, 'context.rb')
  autoload :Census, File.join(LIB_DIR, 'census.rb')
  autoload :Weather, File.join(LIB_DIR, 'weather.rb')
  autoload :CLI, File.join(LIB_DIR, 'cli.rb')
end
