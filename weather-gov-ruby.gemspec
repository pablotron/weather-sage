require_relative './lib/weather-gov'

Gem::Specification.new do |s|
  s.name        = 'weather-gov-ruby'
  s.version     = WeatherGov::VERSION
  s.date        = '2019-08-18'
  s.summary     = 'Wrapper for weather.gov weather API.'
  s.description = 'Wrapper for weather.gov weather API.'
  s.authors     = ['Paul Duncan']
  s.email       = 'pabs@pablotron.org'
  s.homepage    = 'https://github.com/pablotron/weather-gov-ruby'
  s.license     = 'MIT'
  s.files       = Dir['{lib,test}/*'] + %w{README.md Rakefile}
end
