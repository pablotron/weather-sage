require 'json'

#
# HTTP response body parser.
#
class WeatherSage::HTTP::Parser
  #
  # Regex match for known JSON content types.
  #
  JSON_CONTENT_TYPE_REGEX =
    /^application\/json|text\/json|application\/geo\+json/

  #
  # Create an HTTP response body parser.
  #
  def initialize(log)
    @log = log
  end

  #
  # Parse HTTP response body.
  #
  def parse(resp)
    # FIXME: need to extract encoding from content-type
    resp.body.force_encoding('UTF-8')

    r = case resp.content_type
    when JSON_CONTENT_TYPE_REGEX
      # parse and return json
      JSON.parse(resp.body)
    else
      # return string
      resp.body
    end

    @log.debug('Parser#parse') do
      JSON.unparse({
        type: resp.content_type,
        data: r,
      })
    end

    # return response
    r
  end
end
