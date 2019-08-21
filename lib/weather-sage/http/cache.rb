#
# HTTP cache backed by file.
#
class WeatherSage::HTTP::Cache
  attr :path, :timeout

  #
  # Create an HTTP cache backed by file at +path+ where entries are
  # valid for +timeout+ seconds.
  #
  # +timeout+ defaults to 30 minutes if unspecified.
  #
  def initialize(path, log, timeout = 30 * 60)
    @path, @log, @timeout = path.freeze, log, timeout
    @cache = ::WeatherSage::Cache.new(@path)
    @fetcher = ::WeatherSage::HTTP::Fetcher.new(@log)
    @parser = ::WeatherSage::HTTP::Parser.new(@log)
  end

  #
  # Get cached URL, or request it if it is not cached.
  #
  def get(url, params = {})
    # parse URL into URI, get key
    uri = make_uri(url, params)
    str = uri.to_s

    @log.debug('HTTP::Cache#get') { '%s' % [str] }

    unless r = @cache.get(str)
      # fetch response, parse body, and cache result
      r = @cache.set(str, parse(fetch(uri)), @timeout)
    end

    # return result
    r
  end

  #
  # Returns true if the given URL in the cache.
  #
  def key?(url, params = {})
    @cache.key?(make_uri(url, params).to_s)
  end

  private

  #
  # Convert a URL and parameters to a URI.
  #
  def make_uri(url, params = {})
    uri = URI.parse(url)
    uri.query = URI.encode_www_form(params) if params.size > 0
    uri
  end

  #
  # Fetch URI, and return response.
  #
  # Raises an WeatherSage::HTTP::Error on error.
  #
  def fetch(uri)
    @fetcher.fetch(uri)
  end

  #
  # Parse HTTP response body.
  #
  def parse(resp)
    @parser.parse(resp)
  end
end
