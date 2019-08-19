#
# Environment wrapper.
#
class WeatherSage::CLI::Env::Env
  #
  # Create a new environment wrapper.
  #
  def initialize(env)
    @env = env
  end

  #
  # Get the value of the given environment variable.
  #
  def get(id, default = nil)
    key = expand(id)
    @env.key?(key) ? @env[key] : default
  end

  #
  # Does the given ID exist in the environment?
  #
  def key?(id)
    @env.key?(expand(id))
  end

  private

  #
  # Prefix ID to get full environment variable name.
  #
  def expand(id)
    'WEATHER_SAGE_' + id.upcase
  end
end
