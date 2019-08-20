#
# Namespace for data for *help* command.
#
module WeatherSage::CLI::Help
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
      '%<cmds>s',
      '',
      'Use "help <command>" to see detailed help for a command.',
      '',
      'Environment Variables:',
      '%<envs>s',
    ].join("\n"),

    one: [
      '%<label>s %<line>s',
      '',
      '%<full>s',
    ].join("\n"),

    cmd: '  %-10<label>s %<line>s',

    env: [
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
end
