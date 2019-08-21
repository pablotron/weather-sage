require 'fileutils'
require 'logger'
require 'minitest/autorun'
require_relative '../lib/weather-sage'

class TestWeatherSageCensusGeocoder < Minitest::Test
  #
  # Test addresses.
  #
  TESTS = [{
    text: '2565 van buren st eugene or 97405',
    want: [-123.109825, 44.03039],
  }, {
    text: '1600 pennsylvania ave nw washington dc',
    want: [-77.03535, 38.898754],
  }, {
    text: '3150 fairview park dr falls church va 22042',
    want: [-77.216194, 38.859795],
  }]

  def setup
    # create temporary directory that is removed on exit
    @dir = Dir.mktmpdir('test-census-geocoder')
    at_exit { FileUtils.rm_r(@dir) }

    # build absolute path to backing store for cache
    cache_path = File.join(@dir, 'cache.pstore')

    # create null logger
    log = ::Logger.new('/dev/null')

    # create cache instance
    cache = WeatherSage::HTTP::Cache.new(cache_path, log)

    # create and save context
    @ctx = WeatherSage::Context.new(log, cache)

    # create and save geocoder
    @geocoder = WeatherSage::Census::Geocoder.new(@ctx)
  end

  def test_new
    # create new geocoder
    assert WeatherSage::Census::Geocoder.new(@ctx)
  end

  def test_run
    # assert that geocoder can geocode a single address
    assert @geocoder.run(TESTS.first[:text])
  end

  def test_results
    TESTS.each do |test|
      # geocode address, get first result
      pt = @geocoder.run(test[:text]).first.point

      assert_in_delta pt.x, test[:want][0]
      assert_in_delta pt.y, test[:want][1]
    end
  end
end
