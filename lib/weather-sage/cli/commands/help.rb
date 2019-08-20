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
  # Print full list of commands.
  #
  def list_commands
    puts template(:all, {
      app: File.basename(@app),

      cmds: ::WeatherSage::CLI::Help::COMMANDS.values.map { |cmd|
        template(:cmd, cmd)
      }.join("\n"),

      envs: ::WeatherSage::CLI::Env::VARS.map { |row|
        template(:env, row)
      }.join("\n\n"),
    })
  end

  #
  # Print details of given commands.
  #
  def show_details(args)
    # get a list of unknown commands
    unknown_cmds = args.select do |arg|
      !WeatherSage::CLI::Help::COMMANDS.key?(arg)
    end

    if unknown_cmds.size > 0
      # print list of unknown commands and exit
      puts 'Unknown commands: %s' % [unknown_cmds.join(', ')]
      exit -1
    end

    # print detailed help for each argument
    puts args.map { |arg| template(:one, commands[arg]) }
  end

  #
  # Expand template.
  #
  def template(key, args = {})
    unless WeatherSage::CLI::Help::TEMPLATES.key?(key)
      raise "unknown template: #{key}"
    end

    WeatherSage::CLI::Help::TEMPLATES[key] % args
  end
end
