Weather Sage
============
Get weather for address from nearest weather station.

Examples:

```
# get weather forecast
> bin/weather-sage forecast '1600 pennsylvania ave washington dc'
address,name,temperature,temperature_unit,wind_speed,wind_direction,short_forecast
1600 pennsylvania ave washington dc,Today,97,F,7 mph,SW,Scattered Showers And Thunderstorms
1600 pennsylvania ave washington dc,Tonight,76,F,2 to 7 mph,SW,Scattered Showers And Thunderstorms then Mostly Cloudy
1600 pennsylvania ave washington dc,Tuesday,94,F,6 mph,E,Slight Chance Rain Showers then Chance Showers And Thunderstorms
1600 pennsylvania ave washington dc,Tuesday Night,75,F,2 to 6 mph,S,Chance Showers And Thunderstorms
1600 pennsylvania ave washington dc,Wednesday,94,F,3 to 9 mph,SW,Chance Showers And Thunderstorms
1600 pennsylvania ave washington dc,Wednesday Night,76,F,5 to 8 mph,SW,Chance Showers And Thunderstorms
...
```

```
# get current weather
> weather-sage now '1600 pennsylvania ave washington dc'
address,name,type,value,unit,quality_control
1600 pennsylvania ave washington dc,timestamp,time,2019-08-19T06:52:00+00:00
1600 pennsylvania ave washington dc,textDescription,text,Mostly Cloudy
1600 pennsylvania ave washington dc,temperature,value,26.700000000000045,unit:degC,qc:V
1600 pennsylvania ave washington dc,relativeHumidity,value,81.65039907186703,unit:percent,qc:C
...
```

Other useful commands:
* `geocode`: Geocode an address.
* `stations`: List weather stations near an address.

A [Ruby][] interface is also available.

Information sources:
* [National Weather Service Weather API][weather-api]
* [Census Bureau Geocoding API][census-api]

  [ruby]: https://ruby-lang.org/ "Ruby programming language"
  [weather-api]: https://api.weather.gov/ "national Weather Service (NWS) Weather API"
  [census-api]: https://geocoding.geo.census.gov/geocoder/ "Census Bureau Geocoding API"
