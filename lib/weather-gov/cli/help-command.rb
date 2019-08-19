module WeatherGov
  module CLI
    #
    # Implementation of *help* command-line command.
    #
    class HelpCommand < Command
      #
      # Help for this command.
      #
      # Used by the *help* command.
      #
      HELP = {
        line: '
          Print list of all commands.
        '.strip,

        full: [
          'Print a list of all commands.  Use "help <command>" to show',
          'additional details for a specific command.',
        ].join("\n"),
      }.freeze

      #
      # Entry point for *help* command-line command.
      #
      def run(args)
        if args.size > 0
          # show details of given commands
          show_details(args)
        else
          # print full list of commands
          list_commands
        end
      end

      private

      #
      # Help templates.
      #
      TEMPLATES = {
        all: [
          '%<app>s: Weather and geocoding utility.',
          '',
          'This command uses the Census bureau geocoding API to convert',
          'street addresses to latitude/longitude coordinates, and the',
          'National Weather Service weather API to obtain observations',
          'from the nearest weather station.',
          '',
          'Usage:',
          '  %<app>s <command> [args...]',
          '',
          'Commands:',
          '%<commands>s',
          '',
          'Use "help <command>" for detailed help.',
        ].join("\n"),

        one: [
          '%<label>s %<line>s',
          '',
          '%<full>s',
        ].join("\n"),

        cmd: '  %-10<label>s %<line>s',
      }.freeze

      #
      # Print full list of commands.
      #
      def list_commands
        puts TEMPLATES[:all] % {
          app: File.basename(@app),
          commands: commands.values.map { |cmd|
            TEMPLATES[:cmd] % cmd
          }.join("\n")
        }
      end

      #
      # Print details of given commands.
      #
      def show_details(args)
        # get a list of unknown commands
        unknown = args.select { |arg| !commands.key?(arg) }
        if unknown.size > 0
          # print list of unknown commands and exit
          puts 'Unknown commands: %s' % [unknown.join(', ')]
          exit -1
        end

        # print detailed help for each argument
        puts args.map { |arg| TEMPLATES[:one] % commands[arg] }
      end

      #
      # Get a map of command name to command help.
      #
      # The keys in this hash are sorted by command name.
      #
      def commands
        @commands ||= CLI.constants.select { |sym|
          # filter on commands
          sym.to_s.match(/^\w+Command$/)
        }.sort.reduce({}) do |r, key|
          # get command id
          id = key.to_s.gsub(/Command$/, '').downcase

          # get help data, add to results
          r[id] = CLI.const_get(key).const_get(:HELP).merge({
            label: id + ':',
          })

          # return results
          r
        end
      end
    end
  end
end
