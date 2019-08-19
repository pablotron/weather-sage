module WeatherSage
  module CLI
    module Commands
      #
      # Implementation of *geocode* command.
      #
      class GeocodeCommand < Command
        #
        # Help for this command.
        #
        # Used by the *help* command.
        #
        HELP = {
          line: '
            Geocode address.
          '.strip,

          full: [
            'Geocode address.',
          ].join("\n"),
        }.freeze

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
end
