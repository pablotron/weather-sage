module WeatherGov
  #
  # Command-line interface for weathergov.
  #
  module CLI
    autoload :Command, File.join(__dir__, 'cli', 'command.rb')
    autoload :HelpCommand, File.join(__dir__, 'cli', 'help-command.rb')
    autoload :GeocodeCommand, File.join(__dir__, 'cli', 'geocode-command.rb')
    autoload :GetCommand, File.join(__dir__, 'cli', 'get-command.rb')

    #
    # Default cache path.
    #
    CACHE_PATH = '~/.config/weathergov/http-cache.pstore'
    
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
    # Create context from environment variables.
    #
    def self.get_context
      # create logger
      log = ::Logger.new(if ENV.key?('WEATHERGOV_LOG_PATH') 
        File.open(ENV['WEATHERGOV_LOG_PATH'],'ab')
      else
        STDERR
      end)

      # set log level
      log.level = ::Logger.const_get((ENV['WEATHERGOV_LOG_LEVEL'] || 'info').upcase)

      # get cache path
      unless cache_path = ENV['WEATHERGOV_CACHE_PATH']
        cache_path = File.expand_path(CACHE_PATH)
        FileUtils.mkdir_p(File.dirname(cache_path))
      end

      # create and return context
      Context.new(log, HttpCache.new(cache_path))
    end
  end
end
