#
# Matching address returned by Geocoder.
#
class WeatherSage::Census::Match
  attr :point, :address, :data

  #
  # Create a new Match object.
  #
  def initialize(ctx, data)
    # get coordinates
    x, y = %w{x y}.map { |k| data['coordinates'][k] }

    # cache data, address, and point
    @data = data.freeze
    @address = @data['matchedAddress']
    @point = ::WeatherSage::Weather::Point.new(ctx, x, y).freeze
  end
end
