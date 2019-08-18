require_relative './lib/weather-gov'

Gem::Specification.new do |s|
  s.name        = 'weather-gov-ruby'
  s.version     = WeatherGov::VERSION
  s.date        = '2019-08-18'
  s.authors     = ['Paul Duncan']
  s.email       = 'pabs@pablotron.org'
  s.homepage    = 'https://github.com/pablotron/weather-gov-ruby'
  s.license     = 'MIT'
  s.summary     = 'Client for the National Weather Service weather API.'
  s.description = '
    Ruby library and command-line client for accessing the National
    Weather Service (NWS) weather API and the Census bureau geocoding
    API.
  '

  s.metadata = {
    'bug_tracker_uri'   => 'https://github.com/pablotron/weather-gov-ruby/issues',
    "documentation_uri" => 'https://pablotron.github.io/weather-gov-ruby/',
    "homepage_uri"      => 'https://github.com/pablotron/weather-gov-ruby',
    "source_code_uri"   => 'https://github.com/pablotron/weather-gov-ruby',
    "wiki_uri"          => 'https://github.com/pablotron/weather-gov-ruby/wiki',
  }

  s.files = Dir['{bin,lib,test}/*'] + %w{
    README.md
    license.txt
    Rakefile
  }
end
