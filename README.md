Weather Sage
============
Ruby library and command-line tool to get the weather forecast and
current weather observations for an address.

Uses the [Census Bureau Geocoding API][census-api] to geocode street
addresses, and the [National Weather Service Weather API][weather-api]
to get weather forecasts and current weather observations.

Here's an example of using the command-line tool to get the current
weather forecast for the address "1600 pennsylvania ave nw, washington
dc":

```
> bin/weather-sage forecast '1600 pennsylvania ave nw washington dc'
address,name,temperature,temperature_unit,wind_speed,wind_direction,short_forecast
1600 pennsylvania ave washington dc,Today,97,F,7 mph,SW,Scattered Showers And Thunderstorms
1600 pennsylvania ave washington dc,Tonight,76,F,2 to 7 mph,SW,Scattered Showers And Thunderstorms then Mostly Cloudy
1600 pennsylvania ave washington dc,Tuesday,94,F,6 mph,E,Slight Chance Rain Showers then Chance Showers And Thunderstorms
1600 pennsylvania ave washington dc,Tuesday Night,75,F,2 to 6 mph,S,Chance Showers And Thunderstorms
1600 pennsylvania ave washington dc,Wednesday,94,F,3 to 9 mph,SW,Chance Showers And Thunderstorms
1600 pennsylvania ave washington dc,Wednesday Night,76,F,5 to 8 mph,SW,Chance Showers And Thunderstorms
...
```

Installation
------------
Install via [RubyGems][]:

```
# install weather-sage
> sudo gem install weather-sage
```

Examples
--------
**Get weather forecast for an address:**
```
# get weather forecast for address
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

**Get current observations from nearest weather station:**
```
# get current observations from nearest weather station
> weather-sage now '1600 pennsylvania ave washington dc'
address,name,type,value,unit,quality_control
1600 pennsylvania ave washington dc,timestamp,time,2019-08-19T06:52:00+00:00
1600 pennsylvania ave washington dc,textDescription,text,Mostly Cloudy
1600 pennsylvania ave washington dc,temperature,value,26.700000000000045,unit:degC,qc:V
1600 pennsylvania ave washington dc,relativeHumidity,value,81.65039907186703,unit:percent,qc:C
...
```

Commands
--------
Available commands in command-line interface.

* `forecast`: Get weather forecast for address.
* `geocode`: Geocode address.
* `help`: List commands.
* `hourly`: Get hourly weather forecast for address.
* `now`: Get current weather from station closest to address.
* `stations`: List weather stations near address.

Environment Variables
---------------------
The command-line tool can be configured via the following environment
variables:

* `WEATHER_SAGE_LOG_LEVEL`: Log level. One of: `fatal`, `error`,
  `warning`, `info`, `debug`). Defaults to `warn`.
* `WEATHER_SAGE_LOG_PATH`: Path to log file. Defaults to standard error.
* `WEATHER_SAGE_CACHE_PATH`: Path to HTTP cache. Defaults to
  `~/.config/weather-sage/http-cache.pstore`.

  [ruby]: https://ruby-lang.org/ "Ruby programming language"
  [rubygems]: https://rubygems.org/ "Ruby package manager"
  [weather-api]: https://api.weather.gov/ "national Weather Service (NWS) Weather API"
  [census-api]: https://geocoding.geo.census.gov/geocoder/ "Census Bureau Geocoding API"
