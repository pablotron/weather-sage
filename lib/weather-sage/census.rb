module WeatherSage
  #
  # Thin wrapper around Census geocoder.
  #
  module Census
    autoload :Match, File.join(__dir__, 'census', 'match.rb')
    autoload :Geocoder, File.join(__dir__, 'census', 'geocoder.rb')
  end
end
