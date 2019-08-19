require 'time'

#
# Numerical weather forecast.
#
class WeatherSage::Weather::Forecast
  attr :data,
       :updated_at,
       :units,
       :generator,
       :generated_at,
       :update_time,
       :valid_times,
       :elevation,
       :periods

  #
  # Create new forecast object from given data.
  #
  def initialize(ctx, data)
    # cache context and data, get properties
    @ctx, @data = ctx, data.freeze
    props = @data['properties']

    # log data
    @ctx.log.debug('Forecast#initialize') do
      'data = %p' % [@data]
    end

    @updated_at = Time.parse(props['updated'])
    @units = props['units']
    @generator = props['generator']
    @generated_at = Time.parse(props['generatedAt'])
    @update_time = Time.parse(props['updateTime'])
    @valid_times = props['validTimes']
    @elevation = props['elevation']['value']
  end

  #
  # Return an array of periods for this forecast.
  #
  def periods
    @periods ||= @data['properties']['periods'].map { |row|
      ::WeatherSage::Weather::Period.new(@ctx, row)
    }
  end
end
