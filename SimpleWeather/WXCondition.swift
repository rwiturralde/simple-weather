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
    var humidity: NSNumber
    var temperature: NSNumber
    var tempHigh: NSNumber
    var tempLow: NSNumber
    var locationName: NSString
    var sunrise: NSDate
    var sunset: NSDate
    var conditionDescription: NSString
    var condition: NSString
    var windBearing: NSNumber
    var windSpeed: NSNumber
    var icon: NSString
    
    init!() {
        date = NSDate()
        humidity = 0
        temperature = 0
        tempHigh = 0
        tempLow = 0
        locationName = ""
        sunrise = NSDate()
        sunset = NSDate()
        conditionDescription = ""
        condition = ""
        windBearing = 0
        windSpeed = 0
        icon = ""
    }
    
    private func imageName() -> NSString {
        var map: Dictionary<String, String> = imageMap()
        return map[self.icon]!
    }
    
    func imageMap() -> Dictionary<String, String> {
        return [
                "01d" : "weather-clear",
                "02d" : "weather-few",
                "03d" : "weather-few",
                "04d" : "weather-broken",
                "09d" : "weather-shower",
                "10d" : "weather-rain",
                "11d" : "weather-tstorm",
                "13d" : "weather-snow",
                "50d" : "weather-mist",
                "01n" : "weather-moon",
                "02n" : "weather-few-night",
                "03n" : "weather-few-night",
                "04n" : "weather-broken",
                "09n" : "weather-shower",
                "10n" : "weather-rain-night",
                "11n" : "weather-tstorm",
                "13n" : "weather-snow",
                "50n" : "weather-mist",
            ]
    }
    
    func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        return [
            "date": "dt",
            "locationName": "name",
            "humidity": "main.humidity",
            "temperature": "main.temp",
            "tempHigh": "main.temp_max",
            "tempLow": "main.temp_min",
            "sunrise": "sys.sunrise",
            "sunset": "sys.sunset",
            "conditionDescription": "weather.description",
            "condition": "weather.main",
            "icon": "weather.icon",
            "windBearing": "wind.deg",
            "windSpeed": "wind.speed"
        ];
    }
    
    
}