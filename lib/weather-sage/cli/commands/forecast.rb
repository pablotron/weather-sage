#
# Implementation of *forecast* command.
#
class WeatherSage::CLI::Commands::ForecastCommand < WeatherSage::CLI::Commands::BaseForecastCommand
  #
  # Help for this command.
  #
  # Used by the *help* command.
  #
  HELP = {
    line: '
      Get weather forecast for address.
    '.strip,

    full: [
      'Get weather forecast for address.',
      '',
      'Use --full to see additional columns.',
    ].join("\n")
  }.freeze

  #
  # Forecast method.
  #
  # Used by BaseForecastCommand to call correct forecast method.
  #
  FORECAST_METHOD = :forecast
end
