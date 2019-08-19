#
# Namespace for HTTP classes.
#
module WeatherSage::HTTP
  autoload :Error, File.join(__dir__, 'http', 'error.rb')
  autoload :Parser, File.join(__dir__, 'http', 'parser.rb')
  autoload :Fetcher, File.join(__dir__, 'http', 'fetcher.rb')
  autoload :Cache, File.join(__dir__, 'http', 'cache.rb')
end
