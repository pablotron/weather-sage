module WeatherSage
  module Weather
    #
    # Numerical weather forecast.
    #
    class ForecastPeriod
      attr :data,
           :name,
           :start_time,
           :end_time,
           :is_daytime,
           :temperature,
           :temperature_unit,
           :temperature_trend,
           :wind_speed,
           :wind_direction,
           :icon,
           :short_forecast,
           :detailed_forecast

      #
      # Create new forecast period from given data.
      #
      def initialize(ctx, data)
        @ctx = ctx
        @data = data.freeze

        # log data
        @ctx.log.debug('ForecastPeriod#initialize') do
          'data = %p' % [data]
        end

        @name = data['name']
        @start_time = Time.parse(data['startTime'])
        @end_time = Time.parse(data['endTime'])
        @is_daytime = data['isDaytime']
        @temperature = data['temperature']
        @temperature_unit = data['temperatureUnit']
        @temperature_trend = data['temperatureTrend']
        @wind_speed = data['windSpeed']
        @wind_direction = data['windDirection']
        @icon = data['icon']
        @short_forecast = data['shortForecast']
        @detailed_forecast = data['detailedForecast']
      end
    end
  end
end
