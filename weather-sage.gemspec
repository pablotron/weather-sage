require_relative './lib/weather-sage'

Gem::Specification.new do |s|
  s.name        = 'weather-sage'
  s.version     = WeatherSage::VERSION
  s.date        = '2019-08-18'
  s.authors     = ['Paul Duncan']
  s.email       = 'pabs@pablotron.org'
  s.homepage    = 'https://github.com/pablotron/weather-sage'
  s.license     = 'MIT'
  s.summary     = 'Get weather forecast for an address.'
  s.description = '
    Ruby library and command-line tool to get the weather forecast and
    current weather observations for an address.

    Uses the Census Bureau Geocoding API to geocode street addresses,
    and the National Weather Service Weather API to get weather
    forecasts and current weather observations.
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
