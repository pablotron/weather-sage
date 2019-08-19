module WeatherSage
  module Weather
    #
    # Thin wrapper around weather station.
    #
    class Station < BaseObject
      attr :id, :name, :x, :y, :elevation, :time_zone

      #
      # Create a new Station from the given Context +ctx+ and the JSON
      # data +row+.
      #
      def self.from_json(ctx, row)
        new(
          ctx,
          row['properties']['stationIdentifier'],
          row['properties']['name'],
          row['geometry']['coordinates'][0],
          row['geometry']['coordinates'][1],
          row['properties']['elevation']['value'],
          row['properties']['timeZone']
        )
      end

      #
      # Create a new station instance.
      #
      def initialize(ctx, id, name, x, y, elevation, time_zone)
        @ctx = ctx
        @id = id
        @name = name
        @x = x
        @y = y
        @elevation = elevation
        @time_zone = time_zone
      end

      #
      # Return a hash of the latest observations from this station.
      #
      def latest_observations
        path = 'stations/%s/observations/latest' % [@id]
        get(path)['properties']
      end 
    end
  end
end

