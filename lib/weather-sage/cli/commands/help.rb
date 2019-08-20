#
# Implementation of *help* command-line command.
#
class WeatherSage::CLI::Commands::HelpCommand < ::WeatherSage::CLI::Commands::Command
  #
  # Help for this command.
  #
  # Used by the *help* command.
  #
  HELP = {
    line: '
      List commands.
    '.strip,

    full: [
      'List commands.  Use "help <command>" to show details for a',
      'specific command.',
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
      'Use "help <command>" to see detailed help for a command.',
      '',
      'Environment Variables:',
      '%<env_vars>s',
    ].join("\n"),

    one: [
      '%<label>s %<line>s',
      '',
      '%<full>s',
    ].join("\n"),

    cmd: '  %-10<label>s %<line>s',

    env_var: [
      '* WEATHER_SAGE_%<name>s: %<text>s.',
      '  Defaults to %<default>s.',
    ].join("\n"),
  }.freeze

  #
  # Build map of command name to command help.
  #
  # Note: The keys in this hash are sorted by command name.
  #
  COMMANDS = WeatherSage::CLI::Commands.constants.select { |sym|
    sym.to_s.match(/^\w+Command$/)
  }.sort.reduce({}) do |r, sym|
    # limit to commands with a HELP constant
    if WeatherSage::CLI::Commands.const_get(sym).const_defined?(:HELP)
      # get help data
      help = WeatherSage::CLI::Commands.const_get(sym).const_get(:HELP)

      # build command id
      id = sym.to_s.gsub(/Command$/, '').downcase

      # add to results
      r[id] = help.merge({
        label: id + ':',
      })
    end

    # return results
    r
  end.freeze

  #
  # Print full list of commands.
  #
  def list_commands
    puts TEMPLATES[:all] % {
      app: File.basename(@app),

      commands: COMMANDS.values.map { |cmd|
        TEMPLATES[:cmd] % cmd
      }.join("\n"),

      env_vars: ::WeatherSage::CLI::Env::VARS.map { |row|
        TEMPLATES[:env_var] % row
      }.join("\n\n"),
    }
  end

  #
  # Print details of given commands.
  #
  def show_details(args)
    # get a list of unknown commands
    unknown = args.select { |arg| !COMMANDS.key?(arg) }
    if unknown.size > 0
      # print list of unknown commands and exit
      puts 'Unknown commands: %s' % [unknown.join(', ')]
      exit -1
    end

    # print detailed help for each argument
    puts args.map { |arg| TEMPLATES[:one] % commands[arg] }
  end
end
