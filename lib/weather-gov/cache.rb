require 'pstore'

module WeatherGov
  #
  # Cache entry.
  #
  class CacheEntry < ::Struct.new(:expires, :value)
    #
    # Is this cache entry valid?
    #
    def valid?
      expires ? (Time.now.to_i < expires) : true
    end
  end

  #
  # Minimal cache implementation.
  #
  class Cache
    #
    # Create a new Cache instance bound to file at path +path+.
    #
    def initialize(path)
      @pstore = ::PStore.new(path)
    end

    #
    # Returns true if the key exists and is it still valid.
    #
    def key?(key)
      @pstore.transaction(true) do
        return false unless entry = @pstore[key]
        entry.valid?
      end
    end

    #
    # Set entry in cache with key +key+ to value +val+.
    #
    # An optional timeout (in seconds) may be provided with +timout+.
    #
    def set(key, val, timeout = nil)
      @pstore.transaction do
        # calculate expiration time
        expires = timeout ? (Time.now.to_i + timeout) : nil

        # save entry
        @pstore[key] = CacheEntry.new(expires, val)

        # purge any expired entries
        flush
      end

      # return value
      val
    end

    #
    # Get entry in cache with key +key+.
    #
    # Returns *nil* if no such entry exists.
    #
    def get(key)
      @pstore.transaction(true) do
        return nil unless entry = @pstore[key]
        entry.valid? ? entry.value : nil
      end
    end

    #
    # Delete entry in cache with key +key+.
    #
    def delete(key)
      @pstore.transaction do
        @pstore.delete(key)
      end
    end

    alias :[] :get
    alias :[]= :set

    private

    #
    # Purge expired entries.
    #
    def flush
      @pstore.roots.each do |key|
        @pstore.delete(key) unless @pstore[key].valid?
      end
    end
  end
end
