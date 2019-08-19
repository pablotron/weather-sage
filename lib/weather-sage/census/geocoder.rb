#
# Wrapper around Census geocoder API.
#
class WeatherSage::Census::Geocoder
  #
  # URL endpoint for Census Geocoder API.
  #
  URL = 'https://geocoding.geo.census.gov/geocoder/locations/onelineaddress'

  #
  # Static parameters for geocoder requests.
  #
  # Source:
  # https://geocoding.geo.census.gov/geocoder/Geocoding_Services_API.pdf
  PARAMS = {
    returntype: 'locations',
    benchmark:  'Public_AR_Current',
    format:     'json',
  }.freeze

  #
  # Create new Geocoder instance.
  #
  def initialize(ctx)
    @ctx = ctx
  end

  #
  # Geocode given address string +s+ and return an array of Match
  # objects.
  #
  def run(s)
    # exec request
    data = @ctx.cache.get(URL, PARAMS.merge({
      address: s,
    }))

    # log data
    @ctx.log.debug('Geocoder#run') do
      'data = %p' % [data]
    end

    # map matches and return result
    data['result']['addressMatches'].map { |row|
      ::WeatherSage::Census::Match.new(@ctx, row)
    }
  end
end
