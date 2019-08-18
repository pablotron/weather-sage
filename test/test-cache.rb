require 'minitest/autorun'
require 'fileutils'
require_relative '../lib/weather-gov'

class TestWeatherGovCache < Minitest::Test
  def setup
    # create temporary directory that is removed on exit
    @dir = Dir.mktmpdir('test-cache')
    at_exit { FileUtils.rm_r(@dir) }

    # build absolute path to backing store for cache
    path = File.join(@dir, 'cache.pstore')

    # create cache instance
    @cache = WeatherGov::Cache.new(path)
  end

  def test_new
    # build absolute path to backing store for cache
    path = File.join(@dir, 'test-new.pstore')

    # asset that cache is not nil
    assert WeatherGov::Cache.new(path)
  end

  def test_set
    key, want = 'test_set', 'bar'
    assert_equal want, @cache.set(key, want)
  end

  def test_get
    # set value
    key, want = 'test_get', 'bar'
    @cache.set(key, want)

    # get value, test result
    got = @cache.get(key)
    assert_equal want, got
  end

  def test_key?
    key, want = 'test_key?', 'bar'
    @cache.set(key, want)
    assert @cache.key?(key)
  end

  def test_set_timeout
    key, want, timeout = 'test_set_timeout', 'bar', 10

    # set long timeout, then get result before expiration
    @cache.set(key, want, timeout)
    assert_equal want, @cache.get(key)
  end

  def test_set_timeout_expired
    key, want, timeout = 'test_set_timeout_expired', 'bar', 0.1

    # set short timeout, then wait for it to pass
    @cache.set(key, want, timeout)
    sleep(timeout + 1)

    assert_nil @cache.get(key)
  end
end
