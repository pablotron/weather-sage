module WeatherGov
  #
  # Command-line interface for weathergov.
  #
  module CLI
    autoload :Command, File.join(__dir__, 'cli', 'command.rb')
    autoload :HelpCommand, File.join(__dir__, 'cli', 'help-command.rb')
    autoload :GeocodeCommand, File.join(__dir__, 'cli', 'geocode-command.rb')
    autoload :NowCommand, File.join(__dir__, 'cli', 'now-command.rb')

    #
    # Default cache path.
    #
    DEFAULT_CACHE_PATH = '~/.config/weather-gov/http-cache.pstore'
    
    #
    # Entry point for command-line interface.
    #
    def self.run(app, args)
      require 'csv'
      require 'logger'
      require 'fileutils'

      args = ['help'] unless args.size > 0

      # map first argument to command, then run it
      (self.const_get('%sCommand' % [
        args.shift.capitalize
      ]) || HelpCommand).run(get_context, app, args)
    end

    #
    # Create Context from environment variables.
    #
    def self.get_context
      # get log level (default to "info" if unspecified)
      log_level = (ENV['WEATHER_GOV_RUBY_LOG_LEVEL'] || 'info').upcase

      # create logger
      log = ::Logger.new(if ENV.key?('WEATHER_GOV_RUBY_LOG_PATH')
        File.open(ENV['WEATHER_GOV_RUBY_LOG_PATH'],'ab')
      else
        # default to standard error
        STDERR
      end)

      # set log level (default to "info" if unspecified)
      log.level = ::Logger.const_get(log_level)

      # get cache path
      unless cache_path = ENV['WEATHER_GOV_RUBY_CACHE_PATH']
        # use default cache path
        cache_path = File.expand_path(DEFAULT_CACHE_PATH)

        # create parent directories (if necessary)
        FileUtils.mkdir_p(File.dirname(cache_path))
      end

      # create cache instance
      cache = HttpCache.new(cache_path, log)

      # create and return context
      Context.new(log, cache)
    end
  end
end
