#
# Command-line interface for weather-sage.
#
module WeatherSage::CLI
  autoload :Commands, File.join(__dir__, 'cli', 'commands.rb')
  autoload :Env, File.join(__dir__, 'cli', 'env.rb')
  autoload :Help, File.join(__dir__, 'cli', 'help.rb')
  autoload :Forecast, File.join(__dir__, 'cli', 'forecast.rb')

  #
  # Entry point for command-line interface.
  #
  def self.run(app, args)
    require 'csv'
    require 'logger'
    require 'fileutils'

    args = ['help'] unless args.size > 0

    # wrap environment and create context
    env = Env::Env.new(ENV)
    ctx = Env::Context.new(env)

    # map first argument to command, then run it
    (Commands.const_get('%sCommand' % [
      args.shift.capitalize
    ]) || Commands::HelpCommand).run(ctx, app, args)
  end
end
