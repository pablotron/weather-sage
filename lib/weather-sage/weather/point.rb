#
# Thin wrapper around lat/long point in weather API.
#
class WeatherSage::Weather::Point < WeatherSage::Weather::BaseObject
  attr :x, :y

  #
  # Create a new Point object at the given longitude +x+ and latitude
  # +y+.
  #
  def initialize(ctx, x, y)
    super(ctx)
    @x, @y = x, y
  end

  #
  # Returns a list of weather stations near this point.
  #
  def stations
    # build request path
    path = 'points/%2.4f%%2C%2.4f/stations' % [@y, @x]

    get(path)['features'].map { |row|
      WeatherSage::Weather::Station.from_json(@ctx, row)
    }
  end

  #
  # Returns a hash of properties for this point.
  #
  def properties
    # build request path
    path = 'points/%2.4f%%2C%2.4f' % [@y, @x]

    # execute request, return properties
    get(path)['properties']
  end

  #
  # Returns a weather forecast for this point.
  #
  def forecast
    forecast_by_type('forecast')
  end

  #
  # Returns an hourly weather forecast for this point.
  #
  def hourly_forecast
    forecast_by_type('forecastHourly')
  end

  private

  #
  # Get forecast type from properties.
  #
  # Remove the scheme, host, and leading slash from the URL provided
  # in the properties.
  #
  def forecast_by_type(forecast_type)
    # parse URI for given request type
    uri = URI.parse(properties[forecast_type])

    # strip scheme, host, and leading slash from URI to build path
    path = uri.path.gsub(/^\//, '')

    # request forecast and build a Forecast object from it
    ::WeatherSage::Weather::Forecast.new(@ctx, get(path))
  end
end
