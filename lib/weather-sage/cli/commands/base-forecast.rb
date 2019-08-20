#
# Base forecast command.
#
# Used by ForecastCommand and HourlyCommand.
#
class WeatherSage::CLI::Commands::BaseForecastCommand < WeatherSage::CLI::Commands::Command
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
    # get mode and args
    mode, args = parse_args(args)

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
  # Extract mode and args from command-line arguments.
  #
  def parse_args(args)
    case args.first
    when /^-f|--full$/
      [:full, args[1 .. -1]]
    when /^-b|--brief$/
      [:brief, args[1 .. -1]]
    else
      [:brief, args]
    end
  end

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
    ::WeatherSage::CLI::Forecast::columns(@forecast_method, mode)
  end
end
