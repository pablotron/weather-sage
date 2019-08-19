module WeatherSage
  module CLI
    #
    # Implementation of *stations* command.
    #
    class StationsCommand < Command
      #
      # Help for this command.
      #
      # Used by the *help* command.
      #
      HELP = {
        line: '
          List weather stations near address.
        '.strip,

        full: [
          'List weather stations near address.',
        ].join("\n")
      }.freeze

      #
      # CSV column names.
      #
      COL_NAMES = %w{
        address
        station_id
        station_name
        x
        y
        elevation
        time_zone
      }.freeze

      #
      # Run *stations* command.
      #
      def run(args)
        CSV(STDOUT) do |csv|
          # write column names
          csv << COL_NAMES

          args.each do |arg|
            # geocode argument, get first point
            if pt = geocode(arg).first
              # walk stations
              pt.point.stations.each do |s|
                csv << make_row(arg, s)
              end
            end
          end
        end
      end

      private

      #
      # Convert station to CSV row.
      #
      def make_row(address, s)
        [address, s.id, s.name, s.x, s.y, s.elevation, s.time_zone]
      end
    end
  end
end
