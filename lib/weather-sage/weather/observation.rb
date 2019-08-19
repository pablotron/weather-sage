#
# Weather station observation metadata.
#
module WeatherSage::Weather::Observation
  #
  # Observation property types.
  #
  PROPERTIES = {
    timestamp:                  :time,
    textDescription:            :text,
    rawMessage:                 :text,
    icon:                       :url,

    temperature:                :value,
    dewpoint:                   :value,
    windDirection:              :value,
    windSpeed:                  :value,
    windGust:                   :value,
    barometricPressure:         :value,
    seaLevelPressure:           :value,
    visibility:                 :value,
    maxTemperatureLast24Hours:  :value,
    minTemperatureLast24Hours:  :value,
    precipitationLastHour:      :value,
    precipitationLast3Hours:    :value,
    precipitationLast6Hours:    :value,
    relativeHumidity:           :value,
    windChill:                  :value,
    heatIndex:                  :value,

    cloudLayers:                :cloud,
  }.freeze
end
