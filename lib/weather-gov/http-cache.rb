require 'unirest'

module WeatherGov
  class HttpCache
    attr :path, :timeout

    #
    # Create an HTTP cache backed by file at +path+ where entries are
    # valid for +timeout+ seconds.
    #
    # +timeout+ defaults to 30 minutes if unspecified.
    #
    def initialize(path, timeout = 30 * 60)
      @path, @timeout = path.freeze, timeout
      @cache = Cache.new(@path)
    end

    #
    # Request headers.
    #
    HEADERS = {
      'Accept'      => 'application/json',
      'User-Agent'  => "weathergov-ruby/#{WeatherGov::VERSION}"
    }.freeze

    #
    # Get cached URL, or request it if it is not cached.
    #
    def get(url, params = {})
      # build key
      key = key_for(url, params)

      unless r = @cache.get(key)
        # execute request
        resp = Unirest.get(url, headers: HEADERS, parameters: params)

        # check for error
        unless success?(resp.code)
          raise HttpError.new(key, resp.code, resp)
        end

        # cache result
        r = @cache.set(key, resp.body, @timeout)
      end

      # return result
      r
    end

    private

    #
    # Returns true if the HTTP response code +code+ is a success code
    # (e.g. 2xx).
    #
    def success?(code)
      (code / 100) == 2
    end

    #
    # Build a cache key for the given URL +url+ and parameter hash
    # +params+.
    #
    def key_for(url, params)
      key = url

      if params.size > 0
        key += '?' + params.map { |k, v| "#{k}=#{v}" }.join('&')
      end

      key
    end
  end
end
