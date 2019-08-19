module WeatherSage
  module CLI
    #
    # Implementation of *now* command-line command.
    #
    class NowCommand < Command
      #
      # Help for this command.
      #
      # Used by the *help* command.
      #
      HELP = {
        line: '
          Get current weather at the closest station to each address.
        '.strip,

        full: [
          'Get current weather at the closest station to each address.',
        ].join("\n")
      }.freeze

      #
      # CSV column names.
      #
      COL_NAMES = %w{
        input_address
        property_name
        property_type
        property_value 
        property_unit
        quality_control
      }.freeze

      #
      # Create NowCommand instance.
      #
      def initialize(ctx, app)
        super(ctx, app)

        # cache geocoder
        @geocoder = Census::Geocoder.new(ctx)
      end

      #
      # Run *now* command.
      #
      def run(args)
        CSV(STDOUT) do |csv|
          # write column names
          csv << COL_NAMES

          # iterate over command-line arguments and write each one
          args.each do |arg|
            # geocode to first point
            if pt = @geocoder.run(arg).first
              # get first station
              if st = pt.point.stations.first
                # get latest observation data
                data = st.latest_observations

                # write observations
                make_rows(arg, data) do |row|
                  csv << row
                end
              end
            end
          end
        end
      end

      private

      #
      # Map observation properties in result to CSV rows and yield each
      # row.
      #
      # (bit of a hack)
      #
      def make_rows(address, data, &block)
        Weather::Observation::PROPERTIES.each do |key, type|
          # get observation
          if v = data[key.to_s]
            # map observation to row, then yield row
            block.call(case type
            when :text, :time, :url
              [address, key, type, v]
            when :value
              [address, key, type, v['value'], v['unitCode'], v['qualityControl']]
            when :cloud
              # hack: only show data for first cloud layer
              base = v.first['base']
              [address, key, type, base['value'], base['unitCode']]
            else
              raise "unkown type: #{type}"
            end)
          end
        end
      end
    end
  end
end
