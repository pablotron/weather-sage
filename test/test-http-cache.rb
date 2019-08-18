require 'minitest/autorun'
require 'open-uri'
require 'fileutils'
require 'logger'
require_relative '../lib/weather-gov'

class TestWeatherGovHttpCache < Minitest::Test
  #
  # list of test urls
  #
  URLS = {
    good: 'https://pablotron.org/',
    bad: 'https://pablotron.org/does-not-exist',
  }

  def setup
    # create temporary directory that is removed on exit
    @dir = Dir.mktmpdir('test-http-cache')
    at_exit { FileUtils.rm_r(@dir) }

    # build absolute path to backing store for cache
    path = File.join(@dir, 'cache.pstore')

    # create null logger
    @log = ::Logger.new('/dev/null')

    # create cache instance
    @cache = WeatherGov::HttpCache.new(path, @log)
  end

  def test_new
    # build absolute path to backing store for cache
    path = File.join(@dir, 'test-new.pstore')

    # asset that cache is not nil
    assert WeatherGov::HttpCache.new(path, @log)
  end

  def test_new_timeout
    # build absolute path to backing store for cache
    path = File.join(@dir, 'test-new-timeout.pstore')

    timeout = 1

    # create cache with timeout
    cache = WeatherGov::HttpCache.new(path, @log, timeout)

    # asset that timeout is saved
    assert_equal timeout, cache.timeout
  end

  def test_get
    # read URl directly
    want = read_url(URLS[:good])

    # get URL through cache
    got = @cache.get(URLS[:good])

    # test result
    assert_equal want, got
  end

  def test_get_bad
    assert_raises(WeatherGov::HttpError) do
      @cache.get(URLS[:bad])
    end
  end

  private

  #
  # Read given URL.
  #
  # FIXME: need to manage encoding with Net::HTTP
  #
  def read_url(url)
    # open(url, 'rb', encoding: 'UTF-8') { |fh| fh.read }
    open(url, 'rb') { |fh| fh.read }
  end
end
