require 'logger'

#
# Create Logger from environment variables.
#
class WeatherSage::CLI::Env::Log < ::Logger
  #
  # Default log level.
  #
  DEFAULT_LEVEL = 'WARN'

  #
  # Create Logger from environment variables.
  #
  # The following environment variables are supported:
  #
  # - WEATHER_SAGE_LOG_LEVEL: Log level.  One of "fatal", "error",
  #   "warning", "info", or "debug".  Defaults to "warn".
  #
  # - WEATHER_SAGE_LOG_PATH: Path to log file.  Defaults to standard
  #   error.
  #
  def initialize(env)
    # get log level (default to "warn" if unspecified)
    level = (env.get('LOG_LEVEL', DEFAULT_LEVEL)).upcase

    # create logger
    super(
      # log path (default to STDERR)
      env.get('LOG_PATH', STDERR),

      # log level (default to WARN)
      level: ::Logger.const_get(level)
    )

    # log level
    info('Env::Log#initialize') do
      'level = %p' % [level]
    end
  end
end
