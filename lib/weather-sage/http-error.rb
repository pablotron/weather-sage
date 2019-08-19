module WeatherSage
  #
  # HTTP error wrapper.
  #
  class HttpError < RuntimeError
    attr :url, :code, :response

    def initialize(url, code, resp)
      @url = url.freeze
      @code = code.freeze
      @response = resp.freeze
    end
  end
end
