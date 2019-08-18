module WeatherGov
  module CLI
    #
    # Implementation of *geocode* command.
    #
    class GeocodeCommand < Command
      #
      # CSV columns.
      #
      CSV_COLS = %w{input_address match_address x y}

      #
      # Entry point for *geocode* command-line command.
      #
      def run(args)
        # create geocoder
        geocoder = Census::Geocoder.new(@ctx)

        CSV(STDOUT) do |csv|
          # write column headers
          csv << CSV_COLS

          # iterate command-line arguments and geocode each one
          args.each do |arg|
            # geocode argument and write results to output CSV
            geocoder.run(arg).each do |row|
              csv << [arg, row.address, row.point.x, row.point.y]
            end
          end
        end
      end
    end
  end
end
