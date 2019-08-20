#
# Implementation of *hourly* command.
#
class WeatherSage::CLI::Commands::HourlyCommand < WeatherSage::CLI::Commands::BaseForecastCommand
  #
  # Help for this command.
  #
  # Used by the *help* command.
  #
  HELP = {
    line: '
      Get hourly weather forecast for address.
    '.strip,

    full: [
      'Get hourly weather forecast for address.',
      '',
      'Use --full to see additional columns.',
    ].join("\n")
  }.freeze

  #
  # Forecast method.
  #
  # Used by BaseForecastCommand to call correct forecast method.
  #
  FORECAST_METHOD = :hourly_forecast
end
