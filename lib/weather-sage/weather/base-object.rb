module WeatherSage
  module Weather
    #
    # Base class for weather API objects.
    #
    class BaseObject
      attr :cache

      #
      # Create a new weather object.
      #
      def initialize(ctx)
        @ctx = ctx
      end

      protected

      #
      # URL format string for API requests.
      #
      API_URL = 'https://api.weather.gov/%s'

      #
      # Request given API endpoint, return response.
      #
      # FIXME: should handle errors too.
      #
      def get(path)
        # build full URL
        url = API_URL % [path]

        # log full URL
        @ctx.log.debug('BaseObject#get') { '%s' % [url] }

        # get URL from cache
        @ctx.cache.get(url)
      end
    end
  end
end
