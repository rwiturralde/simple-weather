//
//  WXCondition.swift
//  SimpleWeather
//
//  Created by Roberto Iturralde on 2/19/15.
//  Copyright (c) 2015 Roberto Iturralde. All rights reserved.
//

import Foundation

class WXCondition {
    
    var date: NSDate
    var humidity: Double
    var temperature: Double
    var tempHigh: Double
    var tempLow: Double
    var locationName: String
    var sunrise: NSDate
    var sunset: NSDate
    var conditionDescription: String
    var condition: String
    var windBearing: Double
    var windSpeed: Double
    var icon: String
    
    init!() {
        date = NSDate()
        humidity = 0.0
        temperature = 0.0
        tempHigh = 0.0
        tempLow = 0.0
        locationName = ""
        sunrise = NSDate()
        sunset = NSDate()
        conditionDescription = ""
        condition = ""
        windBearing = 0.0
        windSpeed = 0.0
        icon = ""
    }
    
    init! (date_: NSDate, humidity_: Double, temperature_: Double, tempHigh_: Double, tempLow_: Double, locationName_: String, sunrise_: NSDate, sunset_: NSDate, conditionDescription_: String, condition_: String, windBearing_: Double, windSpeed_: Double, icon_: String) {
        date = date_
        humidity = humidity_
        temperature = temperature_
        tempHigh = tempHigh_
        tempLow = tempLow_
        locationName = locationName_
        sunrise = sunrise_
        sunset = sunset_
        conditionDescription = conditionDescription_
        condition = condition_
        windBearing = windBearing_
        windSpeed = windSpeed_
        icon = icon_
    }
    
    internal func imageName() -> String {
        var map: Dictionary<String, String> = imageMap()
        return map[self.icon]!
    }
    
    internal func imageMap() -> Dictionary<String, String> {
        
        var map : Dictionary<String, String> = ["01d" : "weather-clear"]
        map["02d"] = "weather-few"
        
        map["03d"] = "weather-few"
        map["04d"] = "weather-broken"
        map["09d"] = "weather-shower"
        map["10d"] = "weather-rain"
        map["11d"] = "weather-tstorm"
        map["13d"] = "weather-snow"
        map["50d"] = "weather-mist"
        map["01n"] = "weather-moon"
        map["02n"] = "weather-few-night"
        map["03n"] = "weather-few-night"
        map["04n"] = "weather-broken"
        map["09n"] = "weather-shower"
        map["10n"] = "weather-rain-night"
        map["11n"] = "weather-tstorm"
        map["13n"] = "weather-snow"
        map["50n"] = "weather-mist"
        
        return map
    }
    
}