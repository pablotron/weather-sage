module WeatherGov
  #
  # Thin wrapper around weather.gov API.
  #
  module Weather
    autoload :BaseObject, File.join(__dir__, 'weather', 'base-object.rb')
    autoload :Observation, File.join(__dir__, 'weather', 'observation.rb')
    autoload :Point, File.join(__dir__, 'weather', 'point.rb')
    autoload :Station, File.join(__dir__, 'weather', 'station.rb')
  end
end
