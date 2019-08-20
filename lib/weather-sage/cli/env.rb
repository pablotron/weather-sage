module WeatherSage
  module CLI
    #
    # Namespace for environment-related classes.
    #
    module Env
      autoload :VARS, File.join(__dir__, 'env', 'vars.rb')
      autoload :Env, File.join(__dir__, 'env', 'env.rb')
      autoload :Log, File.join(__dir__, 'env', 'log.rb')
      autoload :Cache, File.join(__dir__, 'env', 'cache.rb')
      autoload :Context, File.join(__dir__, 'env', 'context.rb')
    end
  end
end
