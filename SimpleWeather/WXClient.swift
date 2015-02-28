//
//  WXClient.swift
//  SimpleWeather
//
//  Created by Roberto Iturralde on 2/19/15.
//  Copyright (c) 2015 Roberto Iturralde. All rights reserved.
//

import Foundation
import CoreLocation

class WXClient : NSObject {
    
    // to convert MPS from the API to MPH
    final var MPS_TO_MPH: Float = 2.23694
    
    var session: NSURLSession
    var currentConditionsURL: String = "http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=imperial"
    var hourlyConditionsURL: String = "http://api.openweathermap.org/data/2.5/forecast?lat=%f&lon=%f&units=imperial&cnt=12"
    var dailyForecastURL: String = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&units=imperial&cnt=7"
    
    internal var inFlight: Bool
    
    override init() {
        var config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: config)
        inFlight = false
        super.init()
    }
    
    /**
        Create a signal connecting to the URL provided, that can be subscribed to
        to fetch data from the URL provided. When subscribed, connect to the
    
        :param url The URL to connect to for JSON data
    
        :return A RACSignal to subscribe to for data from the URL endpoint.
    **/
    func fetchJSONFromURL(url: NSURL) -> JSON {
        NSLog("Fetching %@", url.absoluteString!)
        
        var returnJson: JSON? = nil
        
        inFlight = true
        
        // Create url session data task that connects to URL and fetches data.
        // It hands the fetched data to the completion handler, which is defined on the fly.
        var dataTask: NSURLSessionDataTask = self.session.dataTaskWithURL(url,
            completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
                // Handle data returned from the URL
                if (error == nil) {
                    var err: NSError?
                    var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                    
                    if (err != nil) {
                        NSLog("JSON Error \(err!.localizedDescription)")
                    }
                    
                    var json: JSON? = JSON(jsonResult)
                        
                    if (json != nil) {
                        NSLog("Received JSON response...")
                        returnJson = json
                    } else {
                        NSLog("Error: Null JSON!")
                    }
                    self.inFlight = false
                } else {
                    NSLog("Error: %@", error)
                    self.inFlight = false
                }
            })
            
            dataTask.resume()
        
        while(inFlight == true) {
            NSLog("Sleeping for one second to wait for response...")
            NSThread.sleepForTimeInterval(1)
        }
        
        return returnJson!
    }
    
    func fetchCurrentConditionsForLocation(coordinate: CLLocationCoordinate2D) -> WXCondition {
        var urlString: NSString = NSString(format: currentConditionsURL, coordinate.latitude, coordinate.longitude)
        var url: NSURL = NSURL(string: urlString)!
        
        var json: JSON = fetchJSONFromURL(url)
        
        var date: NSDate = NSDate(timeIntervalSince1970: json["dt"].doubleValue)
        var humidity: Double = json["main"]["humdity"].doubleValue
        var temperature: Double = json["main"]["temp"].doubleValue
        var tempHigh: Double = json["main"]["temp_max"].doubleValue
        var templow: Double = json["main"]["temp_min"].doubleValue
        var location: String = json["name"].stringValue
        var sunrise: NSDate = NSDate(timeIntervalSince1970: json["sys"]["sunrise"].doubleValue)
        var sunset: NSDate = NSDate(timeIntervalSince1970: json["sys"]["sunset"].doubleValue)
        var description: String = json["weather"][0]["description"].stringValue
        var condition: String = json["weather"][0]["main"].stringValue
        var windBearing: Double = json["wind"]["deg"].doubleValue
        var windSpeed: Double = json["wind"]["speed"].doubleValue //* MPS_TO_MPH
        var icon: String = json["weather"][0]["icon"].stringValue
        
        
        // Create WXCondition from the JSON data returned
        return WXCondition(date_: date, humidity_: humidity, temperature_: temperature, tempHigh_: tempHigh, tempLow_: templow, locationName_: location, sunrise_: sunrise, sunset_: sunset, conditionDescription_: description, condition_: condition, windBearing_: windBearing, windSpeed_: windSpeed, icon_: icon)
    }
    
    func fetchHourlyForecastForLocation(coordinate: CLLocationCoordinate2D) -> Array<WXCondition> {
        var urlString: NSString = NSString(format: hourlyConditionsURL, coordinate.latitude, coordinate.longitude)
        var url: NSURL = NSURL(string: urlString)!

        var json: JSON = fetchJSONFromURL(url)
        
        var returnHourlyConditions = Array<WXCondition>()
        
        
        
        for var i = 0; i < json["list"].count; ++i {
        
            var date: NSDate = NSDate(timeIntervalSince1970: json["list"][i]["dt"].doubleValue)
            var humidity: Double = json["list"][i]["main"]["humdity"].doubleValue
            var temperature: Double = json["list"][i]["main"]["temp"].doubleValue
            var tempHigh: Double = json["list"][i]["main"]["temp_max"].doubleValue
            var templow: Double = json["list"][i]["main"]["temp_min"].doubleValue
            var location: String = json["list"][i]["name"].stringValue
            var sunrise: NSDate = NSDate(timeIntervalSince1970: json["list"][i]["sys"]["sunrise"].doubleValue)
            var sunset: NSDate = NSDate(timeIntervalSince1970: json["list"][i]["sys"]["sunset"].doubleValue)
            var description: String = json["list"][i]["weather"][0]["description"].stringValue
            var condition: String = json["list"][i]["weather"][0]["main"].stringValue
            var windBearing: Double = json["list"][i]["wind"]["deg"].doubleValue
            var windSpeed: Double = json["list"][i]["wind"]["speed"].doubleValue //* MPS_TO_MPH
            var icon: String = json["list"][i]["weather"][0]["icon"].stringValue
        
        
            // Create WXCondition from the JSON data returned
            returnHourlyConditions.append(WXCondition(date_: date, humidity_: humidity, temperature_: temperature, tempHigh_: tempHigh, tempLow_: templow, locationName_: location, sunrise_: sunrise, sunset_: sunset, conditionDescription_: description, condition_: condition, windBearing_: windBearing, windSpeed_: windSpeed, icon_: icon))
        }
        
        return returnHourlyConditions
    }
    
    func fetchDailyForecastForLocation(coordinate: CLLocationCoordinate2D) -> Array<WXCondition> {
        var urlString: NSString = NSString(format: dailyForecastURL, coordinate.latitude, coordinate.longitude)
        var url: NSURL = NSURL(string: urlString)!
        
        var json: JSON = fetchJSONFromURL(url)
        
        var returnDailyConditions = Array<WXCondition>()
        
        for var i = 0; i < json["list"].count; ++i {
            
            var date: NSDate = NSDate(timeIntervalSince1970: json["list"][i]["dt"].doubleValue)
            var humidity: Double = json["list"][i]["main"]["humdity"].doubleValue
            var temperature: Double = json["list"][i]["main"]["temp"].doubleValue
            var tempHigh: Double = json["list"][i]["temp"]["max"].doubleValue
            var templow: Double = json["list"][i]["temp"]["min"].doubleValue
            var location: String = json["list"][i]["name"].stringValue
            var sunrise: NSDate = NSDate(timeIntervalSince1970: json["list"][i]["sys"]["sunrise"].doubleValue)
            var sunset: NSDate = NSDate(timeIntervalSince1970: json["list"][i]["sys"]["sunset"].doubleValue)
            var description: String = json["list"][i]["weather"][0]["description"].stringValue
            var condition: String = json["list"][i]["weather"][0]["main"].stringValue
            var windBearing: Double = json["list"][i]["wind"]["deg"].doubleValue
            var windSpeed: Double = json["list"][i]["wind"]["speed"].doubleValue //* MPS_TO_MPH
            var icon: String = json["list"][i]["weather"][0]["icon"].stringValue
            
            
            // Create WXCondition from the JSON data returned
            returnDailyConditions.append(WXCondition(date_: date, humidity_: humidity, temperature_: temperature, tempHigh_: tempHigh, tempLow_: templow, locationName_: location, sunrise_: sunrise, sunset_: sunset, conditionDescription_: description, condition_: condition, windBearing_: windBearing, windSpeed_: windSpeed, icon_: icon))
        }
        
        return returnDailyConditions
    }
}
