module WeatherGov
  module CLI
    #
    # Implementation of *help* command-line command.
    #
    class HelpCommand < Command
      #
      # Entry point for *help* command-line command.
      #
      def run(args)
        puts "Usage: #@app [args...]"
      end
    end
  end
end
