require 'fileutils'
require 'logger'
require 'minitest/autorun'
require_relative '../lib/weather-sage'
require_relative './test-helpers'

class WeatherSage::Tests::TestWeatherPoint < Minitest::Test
  #
  # Test addresses.
  #
  TESTS = [{
    id: '2565 van buren st eugene or 97405',
    pt: [-123.109825, 44.03039],
  }, {
    id: '1600 pennsylvania ave nw washington dc',
    pt: [-77.03535, 38.898754],
  }, {
    id: '3150 fairview park dr falls church va 22042',
    pt: [-77.216194, 38.859795],
  }]

  def setup
    # cache test context
    @ctx = WeatherSage::Tests.get_test_context
  end

  def test_new
    # create point from lat/long
    x, y = TESTS.first[:pt]
    assert WeatherSage::Weather::Point.new(@ctx, x, y)
  end
end
