module WeatherSage
  module CLI
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
    end
  end
end
