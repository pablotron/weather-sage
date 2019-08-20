module WeatherSage::CLI::Env
  #
  # Environment variables.
  #
  # Used by *help* command to print available environment variables.
  #
  VARS = [{
    name:     'LOG_LEVEL',
    text:     "Log level (fatal, error, warning, info, debug)",
    default:  'warn',
  }, {
    name:     'LOG_PATH',
    text:     "Path to log file",
    default:  'standard error',
  }, {
    name:     'CACHE_PATH',
    text:     "Path to HTTP cache store",
    default:  "~/.config/weather-sage/http-cache.pstore",
  }].freeze
end
