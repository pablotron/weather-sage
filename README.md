Weather Sage
============
Get weather for address from nearest weather station.

Example:

```
> weather-sage now '1600 pennsylvania ave washington dc'
address,name,type,value,unit,quality_control
1600 pennsylvania ave washington dc,timestamp,time,2019-08-19T06:52:00+00:00
1600 pennsylvania ave washington dc,textDescription,text,Mostly Cloudy
1600 pennsylvania ave washington dc,temperature,value,26.700000000000045,unit:degC,qc:V
1600 pennsylvania ave washington dc,relativeHumidity,value,81.65039907186703,unit:percent,qc:C
... (lots more observations)
```

You can also use Weather Sage to do the following:
* Geocode an address.
* List weather stations near an address.

A [Ruby][] interface is also available.

Information sources:
* [National Weather Service Weather API][weather-api]
* [Census Bureau Geocoding API][census-api]

  [ruby]: https://ruby-lang.org/ "Ruby programming language"
  [weather-api]: https://api.weather.gov/ "national Weather Service (NWS) Weather API"
  [census-api]: https://geocoding.geo.census.gov/geocoder/ "Census Bureau Geocoding API"
