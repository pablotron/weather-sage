module WeatherSage::Tests
  def self.get_test_context
    unless @ctx
      # create temporary directory that is removed on exit
      @dir = Dir.mktmpdir('test-weather-sage')
      at_exit { FileUtils.rm_r(@dir) }

      # build absolute path to backing store for cache
      cache_path = File.join(@dir, 'cache.pstore')

      # create null logger
      log = ::Logger.new('/dev/null')

      # create cache instance
      cache = WeatherSage::HTTP::Cache.new(cache_path, log)

      # create and save context
      @ctx = WeatherSage::Context.new(log, cache)
    end

    # return cached context
    @ctx
  end
end
