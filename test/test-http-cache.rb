require 'minitest/autorun'
require 'open-uri'
require 'fileutils'
require 'logger'
require_relative '../lib/weather-sage'

class TestWeatherSageHttpCache < Minitest::Test
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
    @cache = WeatherSage::HTTP::Cache.new(path, @log)
  end

  def test_new
    # build absolute path to backing store for cache
    path = File.join(@dir, 'test-new.pstore')

    # asset that cache is not nil
    assert WeatherSage::HTTP::Cache.new(path, @log)
  end

  def test_new_timeout
    # build absolute path to backing store for cache
    path = File.join(@dir, 'test-new-timeout.pstore')

    # set timeout to one second
    timeout = 1

    # create cache with timeout
    cache = WeatherSage::HTTP::Cache.new(path, @log, timeout)

    # asset that timeout is saved
    assert_equal timeout, cache.timeout
  end

  def test_new_timeout_expired
    # build absolute path to backing store for cache
    path = File.join(@dir, 'test-new-timeout.pstore')

    # set timeout to one seconds
    timeout = 1

    # create cache with one second
    cache = WeatherSage::HTTP::Cache.new(path, @log, timeout)

    # get known good url
    cache.get(URLS[:good])

    # wait for entry to expire
    sleep(timeout + 0.1)

    # asset that entry is expired
    assert !cache.key?(URLS[:good])
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
    assert_raises(WeatherSage::HTTP::Error) do
      @cache.get(URLS[:bad])
    end
  end

  private

  #
  # Read given URL.
  #
  # Note: currently forces UTF-8 encoding.
  #
  def read_url(url)
    # open(url, 'rb') { |fh| fh.read }

    # read contents of URL, force UTF-8 encoding
    open(url, 'rb', encoding: 'UTF-8') { |fh| fh.read }
  end
end
