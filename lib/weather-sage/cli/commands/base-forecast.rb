#
# Base forecast command.
#
# Used by ForecastCommand and HourlyCommand.
#
class WeatherSage::CLI::Commands::BaseForecastCommand < WeatherSage::CLI::Commands::Command
  #
  # List of CSV column properties.
  #
  COLUMNS = [{
    name: 'address',
    prop: nil,
    show: %i{forecast hourly_forecast},
  }, {
    name: 'name',
    prop: 'name',
    show: %i{forecast},
  }, {
    name: 'start_time',
    prop: 'startTime',
    show: %i{hourly_forecast},
  }, {
    name: 'end_time',
    prop: 'endTime',
    show: %i{hourly_forecast},
  }, {
    name: 'is_daytime',
    prop: 'isDaytime',
    show: %i{},
  }, {
    name: 'temperature',
    prop: 'temperature',
    show: %i{forecast hourly_forecast},
  }, {
    name: 'temperature_unit',
    prop: 'temperatureUnit',
    show: %i{forecast hourly_forecast},
  }, {
    name: 'temperature_trend',
    prop: 'temperatureTrend',
    show: %i{},
  }, {
    name: 'wind_speed',
    prop: 'windSpeed',
    show: %i{forecast hourly_forecast},
  }, {
    name: 'wind_direction',
    prop: 'windDirection',
    show: %i{forecast hourly_forecast},
  }, {
    name: 'icon',
    prop: 'icon',
    show: %i{},
  }, {
    name: 'short_forecast',
    prop: 'shortForecast',
    show: %i{forecast hourly_forecast},
  }, {
    name: 'detailed_forecast',
    prop: 'detailedForecast',
    show: %i{},
  }].freeze
  #
  # Do not invoke this method directly; subclass this class and
  # override the +run+ method.
  #
  def initialize(ctx, app)
    super(ctx, app)
    @forecast_method = self.class.const_get(:FORECAST_METHOD)
  end

  #
  # Run command.
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
      csv << columns(mode).map { |col| col[:name] }

      args.each do |arg|
        # geocode argument, get first point
        if pt = geocode(arg).first
          # walk forecast periods
          pt.point.send(@forecast_method).periods.each do |p|
            csv << make_row(mode, arg, p)
          end
        end
      end
    end
  end

  private

  #
  # Convert forecast period to CSV row.
  #
  def make_row(mode, address, p)
    [address] + columns(mode).select { |col|
      col[:prop]
    }.map { |col| p.data[col[:prop]] }
  end

  #
  # Get columns for given mode.
  #
  def columns(mode)
    COLUMNS.select { |col|
      (mode == :full) || col[:show].include?(@forecast_method)
    }
  end
end
