#!/usr/bin/env ruby

require 'unirest'

#
# Thin wrapper around weather.gov API.
#
module WeatherGov
  VERSION = '0.1'

  #
  # Thin wrapper around Census geocoder.
  #
  module CensusGeocoder
    #
    # URL endpoint for Census geocoder.
    #
    URL = 'https://geocoding.geo.census.gov/geocoder/locations/onelineaddress'

    #
    # Address matches returned by geocode.
    #
    class Match
      attr :point, :data

      #
      # Create a new Match object.
      #
      def initialize(data)
        coords = data['coordinates']
        @data = data.freeze
        @point = Point.new(coords['x'], coords['y']).freeze
      end
    end

    #
    # r['result']['addressMatches'].first
    # => {"matchedAddress"=>"7309 CAROL LN, FALLS CHURCH, VA, 22042", "coordinates"=>{"x"=>-77.19818, "y"=>38.860714}, "tigerLine"=>{"tigerLineId"=>"75979948", "side"=>"L"}, "addressComponents"=>{"fromAddress"=>"7307", "toAddress"=>"7399", "preQualifier"=>"", "preDirection"=>"", "preType"=>"", "streetName"=>"CAROL", "suffixType"=>"LN", "suffixDirection"=>"", "suffixQualifier"=>"", "city"=>"FALLS CHURCH", "state"=>"VA", "zip"=>"22042"}}

    #
    # Geocode given address string and return an array of Match objects.
    #
    def self.geocode(s)
      Unirest.get(
        URL,

        headers: {
          'Accept' => 'application/json',
        },

        # src: https://geocoding.geo.census.gov/geocoder/Geocoding_Services_API.pdf
        parameters: {
          address: s,
          returntype: 'locations',
          benchmark: 'Public_AR_Current',
          format: 'json',
        }
      ).body['result']['addressMatches'].map { |row|
        Match.new(row)
      }
    end
  end

  module Observation
    #
    # Observation property types.
    #
    PROPERTIES = {
      timestamp:                  :time,
      textDescription:            :text,
      rawMessage:                 :text,
      icon:                       :url,

      temperature:                :value,
      dewpoint:                   :value,
      windDirection:              :value,
      windSpeed:                  :value,
      windGust:                   :value,
      barometricPressure:         :value,
      seaLevelPressure:           :value,
      visibility:                 :value,
      maxTemperatureLast24Hours:  :value,
      minTemperatureLast24Hours:  :value,
      precipitationLastHour:      :value,
      precipitationLast3Hours:    :value,
      precipitationLast6Hours:    :value,
      relativeHumidity:           :value,
      windChill:                  :value,
      heatIndex:                  :value,

      cloudLayers:                :cloud,
    }.freeze
  end

  #
  # Base class for weather API objects.
  #
  class WeatherObject
    protected

    #
    # Format string for API requests.
    #
    API_URL = 'https://api.weather.gov/%s'

    #
    # Request headers.
    #
    HEADERS = {
      'Accept'      => 'application/json',
      'User-Agent'  => "weathergov-ruby/#{VERSION}"
    }.freeze

    #
    # Request given API endpoint, return response.
    #
    # FIXME: should handle errors too.
    #
    def get(path)
      Unirest.get(API_URL % [path], headers: HEADERS).body
    end
  end

  #
  # Thin wrapper around weather station.
  #
  class Station < WeatherObject
    attr :station_id, :name, :x, :y, :elevation, :time_zone 

    #
    # Create a new station from the given JSON data.
    #
    def self.from_json(row)
      new(
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
    def initialize(station_id, name, time_zone, x, y, elevation)
      @station_id = station_id
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
      path = 'stations/%s/observations/latest' % [@station_id]
      get(path)['properties']
    end 
  end

  #
  # Thin wrapper around lat/long point in weather API.
  #
  class Point < WeatherObject
    attr :x, :y

    #
    # Create a new Point object at the given longitude and latitude.
    #
    def initialize(x, y)
      @x, @y = x, y
    end

    #
    # Returns a list of weather stations near the given point.
    #
    def stations
      path = 'points/%2.7f%%2C%2.7f/stations' % [@y, @x]

      get(path)['features'].map { |row|
        Station.from_json(row)
      }
    end
  end

  module CLI
    #
    # Base class for command-line commands.
    #
    class Command
      #
      # Do not invoke this method directly; subclass Command and
      # override the +run+ method.
      #
      def initialize(app)
        @app = app
      end

      #
      # Run command.
      #
      def self.run(app, args)
        new(app).run(args)
      end

      #
      # Virtual method.  You need to subclass and override this method
      # to add a new command.
      #
      def run(args)
        raise "not implemented"
      end
    end

    class HelpCommand < Command
      def run(args)
        puts "Usage: #@app [args...]"
      end
    end

    class GeocodeCommand < Command
      COLS = {
        input: proc { |s, row| s },
        match: proc { |s, row| row['matchedAddress'] },
        x:     proc { |s, row| row['coordinates']['x'] },
        y:     proc { |s, row| row['coordinates']['y'] },
      }.freeze

      def run(args)
        CSV(STDOUT) do |csv|
          csv << COLS.keys
          args.each do |s|
            CensusGeocoder.run(s).each do |row|
              csv << COLS.map { |k, fn| fn.call(s, row) }
            end
          end
        end
      end
    end

    class AtCommand < Command
      # CSV column names
      COL_NAMES = %w{
        input_address
        property_name
        property_type
        property_value 
        property_unit
        quality_control
      }.freeze

      def run(args)
        CSV(STDOUT) do |csv|
          # write column names
          csv << COL_NAMES

          # iterate over command-line arguments and write each one
          args.each do |arg|
            # geocode to first point
            if pt = CensusGeocoder.geocode(arg).first
              # get first station
              if st = pt.point.stations.first
                # get latest observation data
                data = st.latest_observations

                # write observations
                make_rows(arg, data) do |row|
                  csv << row
                end
              end
            end
          end
        end
      end

      private

      def make_rows(address, data, &block)
        Observation::PROPERTIES.each do |key, type|
          # get observation
          if v = data[key.to_s]
            # map observation to row, then yield row
            block.call(case type
            when :text, :time, :url
              [address, key, type, v]
            when :value
              [address, key, type, v['value'], v['unitCode'], v['qualityControl']]
            when :cloud
              # hack: only show data for first cloud layer
              base = v.first['base']
              [address, key, type, base['value'], base['unitCode']]
            else
              raise "unkown type: #{type}"
            end)
          end
        end
      end
    end
    
    def self.run(app, args)
      require 'csv'
      args = ['help'] unless args.size > 0

      # map first argument to command
      cmd = self.const_get('%sCommand' % [args.shift.capitalize]) || HelpAction

      # run command
      cmd.run(app, args)
    end
  end
end

WeatherGov::CLI.run($0, ARGV) if __FILE__ == $0
