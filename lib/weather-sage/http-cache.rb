require 'net/http'
require 'json'

module WeatherSage
  class HttpCache
    attr :path, :timeout

    #
    # Create an HTTP cache backed by file at +path+ where entries are
    # valid for +timeout+ seconds.
    #
    # +timeout+ defaults to 30 minutes if unspecified.
    #
    def initialize(path, log, timeout = 30 * 60)
      @path, @log, @timeout = path.freeze, log, timeout
      @cache = Cache.new(@path)
    end

    #
    # Request headers.
    #
    HEADERS = {
      'Accept'      => 'application/json',
      'User-Agent'  => "weather-sage/#{WeatherSage::VERSION}"
    }.freeze

    #
    # Get cached URL, or request it if it is not cached.
    #
    def get(url, params = {})
      # parse URL into URI, get key
      uri = URI.parse(url)
      uri.query = URI.encode_www_form(params) if params.size > 0
      str = uri.to_s

      @log.debug('HttpCache#get') { '%s' % [str] }

      unless r = @cache.get(str)
        # fetch response, parse body, and cache result
        r = @cache.set(str, parse(fetch(uri)), @timeout)
      end

      # return result
      r
    end

    private

    #
    # Fetch URI, and return response.
    #
    # Raises an HttpError on error.
    #
    def fetch(uri, limit = 5)
      # log uri
      @log.debug('HttpCache#fetch') { '%p' % [uri] }

      # create request, set headers
      req = Net::HTTP::Get.new(uri)
      HEADERS.each { |k, v| req[k] = v }
      use_ssl = (uri.scheme == 'https')

      # connect, fetch response
      resp = Net::HTTP.start(uri.host, uri.port, use_ssl: use_ssl) do |http|
        http.request(req)
      end

      # log response
      @log.debug('HttpCache#fetch') { 'response: %p' % [resp] }

      # check for error
      case resp
      when Net::HTTPSuccess
        resp
      when Net::HTTPRedirection
        # raise error if we've hit the redirect limit
        raise HttpError.new(uri.to_s, resp.code, resp) unless limit > 0

        # get new uri
        new_uri = uri.merge(resp['location'])

        # log redirect
        @log.debug('HttpCache#fetch') do
          'redirect: %s' % [JSON.unparse({
            location: resp['location'],
            old_uri: uri,
            new_uri: new_uri,
          })]
        end

        # decriment limit, redirect
        fetch(new_uri, limit - 1)
      else
        @log.debug('HttpCache#fetch') do
          'HTTP request failed: url = %s, response = %p' % [uri, resp]
        end

        raise HttpError.new(uri.to_s, resp.code, resp)
      end
    end

    #
    # Regex match for known JSON content types.
    #
    JSON_CONTENT_TYPE_REGEX =
      /^application\/json|text\/json|application\/geo\+json/

    #
    # Parse HTTP response body.
    #
    def parse(resp)
      # FIXME: need to extract encoding from content-type
      resp.body.force_encoding('UTF-8')

      r = case resp.content_type
      when JSON_CONTENT_TYPE_REGEX
        # parse and return json
        JSON.parse(resp.body)
      else
        # return string
        resp.body
      end

      @log.debug('HttpCache#parse') do
        JSON.unparse({
          type: resp.content_type,
          data: r,
        })
      end

      # return response
      r
    end
  end
end
