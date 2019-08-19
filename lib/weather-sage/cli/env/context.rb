#
# Create Context from environment variables.
#
class WeatherSage::CLI::Env::Context < ::WeatherSage::Context
  #
  # Create Context from environment variables.
  #
  # The following environment variables are supported:
  #
  # - WEATHER_SAGE_LOG_LEVEL: Log level.  One of "fatal", "error",
  #   "warning", "info", or "debug".  Defaults to "warn".
  #
  # - WEATHER_SAGE_LOG_PATH: Path to log file.  Defaults to standard
  #   error.
  #
  # - WEATHER_SAGE_CACHE_PATH: Path to HTTP cache file.  Defaults to
  #   "~/.config/weather-sage/http-cache.pstore".
  #
  def initialize(env)
    # create log from environment
    log = ::WeatherSage::CLI::Env::Log.new(env)

    # create cache from environment and log
    cache = ::WeatherSage::CLI::Env::Cache.new(env, log)

    # create context
    super(log, cache)
  end
end
