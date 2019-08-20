#
# Namespace containing data for *forecast* and *hourly* commands.
#
module WeatherSage::CLI::Forecast
  #
  # List of forecast CSV columns and properties.
  #
  COLUMNS = [{
    name: 'address',
    prop: nil,
    show: %i{forecast hourly_forecast},
  }, {
    name: 'name',
    prop: 'name',
    show: %i{forecast},
  }, {
    name: 'start_time',
    prop: 'startTime',
    show: %i{hourly_forecast},
  }, {
    name: 'end_time',
    prop: 'endTime',
    show: %i{hourly_forecast},
  }, {
    name: 'is_daytime',
    prop: 'isDaytime',
    show: [],
  }, {
    name: 'temperature',
    prop: 'temperature',
    show: %i{forecast hourly_forecast},
  }, {
    name: 'temperature_unit',
    prop: 'temperatureUnit',
    show: %i{forecast hourly_forecast},
  }, {
    name: 'temperature_trend',
    prop: 'temperatureTrend',
    show: [],
  }, {
    name: 'wind_speed',
    prop: 'windSpeed',
    show: %i{forecast hourly_forecast},
  }, {
    name: 'wind_direction',
    prop: 'windDirection',
    show: %i{forecast hourly_forecast},
  }, {
    name: 'icon',
    prop: 'icon',
    show: [],
  }, {
    name: 'short_forecast',
    prop: 'shortForecast',
    show: %i{forecast hourly_forecast},
  }, {
    name: 'detailed_forecast',
    prop: 'detailedForecast',
    show: [],
  }].freeze

  #
  # Get columns for given forecast method and mode.
  #
  def self.columns(forecast_method, mode)
    COLUMNS.select { |col|
      (mode == :full) || col[:show].include?(forecast_method)
    }
  end
end
