#
# HTTP error wrapper.
#
class WeatherSage::HTTP::Error < ::RuntimeError
  attr :url, :code, :response

  #
  # Create Error instance from URL, response code, and response.
  #
  def initialize(url, code, resp)
    @url = url.freeze
    @code = code.freeze
    @response = resp.freeze
  end
end
