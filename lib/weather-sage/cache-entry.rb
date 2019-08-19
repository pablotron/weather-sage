require 'pstore'

#
# Cache entry.
#
class WeatherSage::CacheEntry < ::Struct.new(:expires, :value)
  #
  # Is this cache entry valid?
  #
  def valid?
    expires ? (Time.now.to_i < expires) : true
  end
end
