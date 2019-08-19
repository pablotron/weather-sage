module WeatherSage
  #
  # Command-line interface for weather-sage.
  #
  module CLI
    autoload :Commands, File.join(__dir__, 'cli', 'commands.rb')
    autoload :EnvContext, File.join(__dir__, 'cli', 'env-context.rb')

    #
    # Entry point for command-line interface.
    #
    def self.run(app, args)
      require 'csv'
      require 'logger'
      require 'fileutils'

      args = ['help'] unless args.size > 0

      # create context
      ctx = EnvContext.new

      # map first argument to command, then run it
      (Commands.const_get('%sCommand' % [
        args.shift.capitalize
      ]) || Commands::HelpCommand).run(ctx, app, args)
    end
  end
end
