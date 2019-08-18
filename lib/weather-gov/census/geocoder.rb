#!/usr/bin/env ruby

require 'unirest'

module WeatherGov
  module Census
    #
    # Wrapper around Census geocoder API.
    #
    class Geocoder
      #
      # URL endpoint for Census geocoder API.
      #
      URL = 'https://geocoding.geo.census.gov/geocoder/locations/onelineaddress'

      #
      # Create new geocoder instance.
      #
      def initialize(ctx)
        @ctx = ctx
      end

      #
      # Geocode given address string +s+ and return an array of Match
      # objects.
      #
      def run(s)
        # reference:
        # https://geocoding.geo.census.gov/geocoder/Geocoding_Services_API.pdf
        body = @ctx.cache.get(URL, {
          address: s,
          returntype: 'locations',
          benchmark: 'Public_AR_Current',
          format: 'json',
        })

        body['result']['addressMatches'].map { |row|
          Match.new(@ctx, row)
        }
      end
    end
  end
end
