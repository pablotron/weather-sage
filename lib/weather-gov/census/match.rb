
module WeatherGov
  module Census
    #
    # Matching address returned by Geocoder.
    #
    class Match
      attr :point, :address, :data

      #
      # Create a new Match object.
      #
      def initialize(ctx, data)
        x, y = %w{x y}.map { |k| data['coordinates'][k] }
        @data = data.freeze
        @address = @data['matchedAddress']
        @point = WeatherGov::Weather::Point.new(ctx, x, y).freeze
      end
    end
  end
end
