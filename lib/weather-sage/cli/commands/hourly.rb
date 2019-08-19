module WeatherSage
  module CLI
    module Commands
      #
      # Implementation of *hourly* command.
      #
      class HourlyCommand < Command
        #
        # Help for this command.
        #
        # Used by the *help* command.
        #
        HELP = {
          line: '
            Get hourly weather forecast for address.
          '.strip,

          full: [
            'Get hourly weather forecast for address.',
            '',
            'Use --full to see additional columns.',
          ].join("\n")
        }.freeze

        #
        # CSV column names.
        #
        COL_NAMES = {
          brief: %w{
            address
            start_time
            end_time
            temperature
            temperature_unit
            wind_speed
            wind_direction
            short_forecast
          },

          full: %w{
            address
            name
            start_time
            end_time
            is_daytime
            temperature
            temperature_unit
            temperature_trend
            wind_speed
            wind_direction
            icon
            short_forecast
            detailed_forecast
          },
        }.freeze

        #
        # Run *hourly* command.
        #
        def run(args)
          # get mode
          mode = case args.first
          when /^-f|--full$/
            args.shift
            :full
          when /^-b|--brief$/
            args.shift
            :brief
          else
            :brief
          end

          CSV(STDOUT) do |csv|
            # write column names
            csv << COL_NAMES[mode]

            args.each do |arg|
              # geocode argument, get first point
              if pt = geocode(arg).first
                # walk forecast periods
                pt.point.hourly_forecast.periods.each do |p|
                  csv << make_row(mode, arg, p)
                end
              end
            end
          end
        end

        private

        #
        # property IDs to extract from forecast period
        #
        PROPERTIES = {
          brief: %w{
            startTime
            endTime
            temperature
            temperatureUnit
            windSpeed
            windDirection
            shortForecast
          },

          full: %w{
            name
            startTime
            endTime
            isDaytime
            temperature
            temperatureUnit
            temperatureTrend
            windSpeed
            windDirection
            icon
            shortForecast
            detailedForecast
          },
        }.freeze

        #
        # Convert forecast period to CSV row.
        #
        def make_row(mode, address, p)
          [address] + PROPERTIES[mode].map { |id| p.data[id] }
        end
      end
    end
  end
end
