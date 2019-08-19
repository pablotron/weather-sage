module WeatherSage
  #
  # Thin wrapper around weather.gov API.
  #
  module Weather
    autoload :BaseObject, File.join(__dir__, 'weather', 'base-object.rb')
    autoload :Observation, File.join(__dir__, 'weather', 'observation.rb')
    autoload :Point, File.join(__dir__, 'weather', 'point.rb')
    autoload :Station, File.join(__dir__, 'weather', 'station.rb')
    autoload :Forecast, File.join(__dir__, 'weather', 'forecast.rb')
    autoload :ForecastPeriod, File.join(__dir__, 'weather', 'forecast-period.rb')
  end
end
