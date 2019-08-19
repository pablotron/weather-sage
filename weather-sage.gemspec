require_relative './lib/weather-gov'

Gem::Specification.new do |s|
  s.name        = 'weather-sage'
  s.version     = WeatherSage::VERSION
  s.date        = '2019-08-18'
  s.authors     = ['Paul Duncan']
  s.email       = 'pabs@pablotron.org'
  s.homepage    = 'https://github.com/pablotron/weather-sage'
  s.license     = 'MIT'
  s.summary     = 'Client for the National Weather Service weather API.'
  s.description = '
    Ruby library and command-line client for accessing the National
    Weather Service (NWS) weather API and the Census bureau geocoding
    API.
  '

  s.metadata = {
    'bug_tracker_uri'   => 'https://github.com/pablotron/weather-sage/issues',
    "documentation_uri" => 'https://pablotron.github.io/weather-sage/',
    "homepage_uri"      => 'https://github.com/pablotron/weather-sage',
    "source_code_uri"   => 'https://github.com/pablotron/weather-sage',
    "wiki_uri"          => 'https://github.com/pablotron/weather-sage/wiki',
  }

  s.files = Dir['{bin,lib,test}/*'] + %w{
    README.md
    license.txt
    Rakefile
  }
end
