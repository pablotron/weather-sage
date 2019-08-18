#
# Minimal wrapper around NOAA weather.gov API and Census bureau
# geocoder API.
#
module WeatherGov
  #
  # Release version.
  #
  VERSION = '0.1'

  autoload :Cache, File.join(__dir__, 'weathergov/cache.rb')
end
