module WeatherSage
  #
  # Minimal context containing a logger and HTTP request cache.
  #
  class Context
    attr :log, :cache

    #
    # Create context from given +log+ and +cache+.
    #
    def initialize(log, cache)
      @log, @cache = log, cache
    end
  end
end
