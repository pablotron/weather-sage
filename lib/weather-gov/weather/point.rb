module WeatherGov
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
      # Returns a list of weather stations near the given point.
      #
      def stations
        path = 'points/%2.7f%%2C%2.7f/stations' % [@y, @x]

        get(path)['features'].map { |row|
          Station.from_json(@ctx, row)
        }
      end
    end
  end
end
