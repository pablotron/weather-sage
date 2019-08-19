module WeatherSage
  module Weather
    #
    # Thin wrapper around lat/long point in weather API.
    #
    class Point < BaseObject
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
        path = 'points/%2.4f%%2C%2.4f/stations' % [@y, @x]

        get(path)['features'].map { |row|
          Station.from_json(@ctx, row)
        }
      end

      #
      # Returns a hash of properties for this point.
      #
      def properties
        path = 'points/%2.4f%%2C%2.4f' % [@y, @x]
        get(path)['properties']
      end

      #
      # Returns a weather forecast for this point.
      #
      def forecast
        path = get_forecast_path('forecast')
        Forecast.new(@ctx, get(path))
      end

      #
      # Returns an hourly weather forecast for this point.
      #
      def hourly_forecast
        path = get_forecast_path('forecastHourly')
        Forecast.new(@ctx, get(path))
      end

      private

      #
      # Get forecast path from properties.
      #
      # Remove the scheme, host, and leading slash from the URL provided
      # in the properties.
      #
      def get_forecast_path(forecast_type)
        URI.parse(properties[forecast_type]).path.gsub(/^\//, '')
      end
    end
  end
end
