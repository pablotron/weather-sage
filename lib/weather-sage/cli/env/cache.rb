require 'fileutils'

#
# Create HTTP::Cache fron environment variables.
#
class WeatherSage::CLI::Env::Cache < ::WeatherSage::HTTP::Cache
  #
  # Default cache path.
  #
  DEFAULT_PATH = '~/.config/weather-sage/http-cache.pstore'

  #
  # Create HTTP::Cache fron environment variables.
  #
  # Uses the following environment variables:
  #
  # - WEATHER_SAGE_CACHE_PATH: Path to HTTP cache file.  Defaults to
  #   "~/.config/weather-sage/http-cache.pstore".
  #
  def initialize(env, log)
    # get cache path
    unless path = env.get('CACHE_PATH')
      # use default cache path
      path = File.expand_path(DEFAULT_PATH)

      # create parent directories (if necessary)
      FileUtils.mkdir_p(File.dirname(path))
    end

    # log cache path
    log.info('Env::Cache#initialize') do
      'path = %p' % [path]
    end

    # return cache instance
    super(path, log)
  end
end
