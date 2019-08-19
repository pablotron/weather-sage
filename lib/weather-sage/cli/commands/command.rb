module WeatherSage
  module CLI
    module Commands
      #
      # Base class for command-line commands.
      #
      # You should subclass this class to create new commands.
      #
      class Command
        #
        # Do not invoke this method directly; subclass Command and
        # override the +run+ method.
        #
        def initialize(ctx, app)
          @ctx, @app = ctx, app

          # create geocoder
          @geocoder = Census::Geocoder.new(ctx)
        end

        #
        # Run command.
        #
        def self.run(ctx, app, args)
          new(ctx, app).run(args)
        end

        #
        # Virtual method.  You need to subclass and override this method
        # to add a new command.
        #
        def run(args)
          raise "not implemented"
        end

        protected

        #
        # Geocode given street address and return array of
        # Census::Geocode::Match results.
        #
        def geocode(s)
          @geocoder.run(s)
        end
      end
    end
  end
end
