require 'minitest/autorun'
require 'open-uri'
require 'fileutils'
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

    # create cache instance
    @cache = WeatherGov::HttpCache.new(path)
  end

  def test_new
    # build absolute path to backing store for cache
    path = File.join(@dir, 'test-new.pstore')

    # asset that cache is not nil
    assert WeatherGov::HttpCache.new(path)
  end

  def test_new_timeout
    # build absolute path to backing store for cache
    path = File.join(@dir, 'test-new-timeout.pstore')

    timeout = 1

    # create cache with timeout
    cache = WeatherGov::HttpCache.new(path, timeout)

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

  private

  def read_url(url)
    open(url, 'rb', encoding: 'UTF-8') { |fh| fh.read }
  end
end
