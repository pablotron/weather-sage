require 'net/http'

#
# HTTP fetcher.
#
class WeatherSage::HTTP::Fetcher
  #
  # Request headers.
  #
  HEADERS = {
    'Accept'      => 'application/json',
    'User-Agent'  => "weather-sage/#{WeatherSage::VERSION}"
  }.freeze

  #
  # Create an HTTP Fetcher.
  #
  def initialize(log)
    @log = log
  end

  #
  # Fetch URI, and return response.
  #
  # Raises an WeatherSage::HTTP::Error on error.
  #
  def fetch(uri, limit = 5)
    # log uri
    @log.info('Fetcher#fetch') { '%p' % [uri] }

    # create request, set headers
    req = Net::HTTP::Get.new(uri)
    HEADERS.each { |k, v| req[k] = v }
    use_ssl = (uri.scheme == 'https')

    # connect, fetch response
    resp = Net::HTTP.start(uri.host, uri.port, use_ssl: use_ssl) do |http|
      http.request(req)
    end

    # log response
    @log.debug('Fetcher#fetch') { 'response: %p' % [resp] }

    # check for error
    case resp
    when Net::HTTPSuccess
      resp
    when Net::HTTPRedirection
      # have we hit the redirect limit?
      unless limit > 0
        # redirect limit hit, raise error
        raise ::WeatherSage::HTTP::Error.new(uri.to_s, resp.code, resp)
      end

      # get new uri
      new_uri = uri.merge(resp['location'])

      # log redirect
      @log.debug('Fetcher#fetch') do
        'redirect: %s' % [JSON.unparse({
          location: resp['location'],
          old_uri: uri,
          new_uri: new_uri,
        })]
      end

      # decriment limit, redirect
      fetch(new_uri, limit - 1)
    else
      # log error
      @log.debug('Fetcher#fetch') do
        'HTTP request failed: url = %s, response = %p' % [uri, resp]
      end

      # raise error
      raise ::WeatherSage::HTTP::Error.new(uri.to_s, resp.code, resp)
    end
  end
end
