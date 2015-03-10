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
    
    var _session: NSURLSession
    var _currentConditionsURL: String = "http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=imperial"
    var _hourlyConditionsURL: String = "http://api.openweathermap.org/data/2.5/forecast?lat=%f&lon=%f&units=imperial&cnt=12"
    var _dailyForecastURL: String = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&units=imperial&cnt=7"
    
    override init() {
        var config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        _session = NSURLSession(configuration: config)
        super.init()
    }
    
    /**
        Fetch the weather conditions for a given location.
    
        :param: coordinate_ CLLocationCoordinate2D for the location for which we want weather information
        :param: resultHandler_ method to call with the weather data
    */
    func fetchCurrentConditionsForLocation(coordinate_: CLLocationCoordinate2D, resultHandler_: ((AnyObject?) -> Void)) -> Void {
        NSLog("Fetching weather conditions for Lat: \(coordinate_.latitude) Long: \(coordinate_.longitude).")

        var urlString: NSString = NSString(format: _currentConditionsURL, coordinate_.latitude, coordinate_.longitude)
        var url: NSURL = NSURL(string: urlString)!
        
        fetchJSONFromURL(url, resultHandler_)
    }

    /**
        Fetch the hourly forecast for a given location.
        
        :param: coordinate_ CLLocationCoordinate2D for the location for which we want weather information
        :param: resultHandler_ method to call with the weather data
    */
    func fetchHourlyForecastForLocation(coordinate_: CLLocationCoordinate2D, resultHandler_: ((AnyObject?) -> Void)) -> Void {
        NSLog("Fetching hourly forecast for Lat: \(coordinate_.latitude) Long: \(coordinate_.longitude).")

        var urlString: NSString = NSString(format: _hourlyConditionsURL, coordinate_.latitude, coordinate_.longitude)
        var url: NSURL = NSURL(string: urlString)!

        fetchJSONFromURL(url, resultHandler_)
    }
    
    /**
        Fetch the daily forecase for a given location.
        
        :param: coordinate_ CLLocationCoordinate2D for the location for which we want weather information
        :param: resultHandler_ method to call with the weather data
    */
    func fetchDailyForecastForLocation(coordinate_: CLLocationCoordinate2D, resultHandler_: ((AnyObject?) -> Void)) -> Void {
        NSLog("Fetching daily forecast for Lat: \(coordinate_.latitude) Long: \(coordinate_.longitude).")
        
        var urlString: NSString = NSString(format: _dailyForecastURL, coordinate_.latitude, coordinate_.longitude)
        var url: NSURL = NSURL(string: urlString)!
        
        fetchJSONFromURL(url, resultHandler_)
    }
    
    /**
    Fetch JSON data from the URL provided and call the provided handler with the response when it's available
    
    :param: url_ The URL to connect to for JSON data
    :param: resultHandler_ The method to call with the weather condition(s) for the web query
    */
    func fetchJSONFromURL(url_: NSURL, resultHandler_: ((AnyObject?) -> Void)) {
        NSLog("Fetching JSON from URL: \(url_.absoluteString)")
        
        // Create url session data task that connects to URL and fetches data.
        // It hands the fetched data to the completion handler, which is defined on the fly.
        var dataTask: NSURLSessionDataTask = _session.dataTaskWithURL(url_, completionHandler: { (data_: NSData!, response_: NSURLResponse!, error_: NSError!) -> Void in
            // Handle data returned from the URL
            if (error_ == nil) {
                var err: NSError?
                var jsonResult = NSJSONSerialization.JSONObjectWithData(data_, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                
                if (err != nil) {
                    NSLog("JSON Error \(err!.localizedDescription)")
                    resultHandler_(nil)
                }
                
                var json: JSON? = JSON(jsonResult)
                
                if (json != nil) {
                    //NSLog("Received JSON response: \(json)")
                    NSLog("Received JSON response...")
                    resultHandler_(self.getConditionFromJSON(json!))
                } else {
                    NSLog("Error: Null JSON!")
                    resultHandler_(nil)
                }
            } else {
                NSLog("Error: \(error_)")
                resultHandler_(nil)
            }
        })
        
        dataTask.resume()
    }
    
    /**
        Get the weather condition(s) from JSON weather date
        
        :param: json_ JSON object holding the weather data. This can either be JSON for a single 
                weather condition or an array of conditions
        :returns: Either a WXCondition for the single weather condition or an Array<WXCondition> for hourly/daily forecasts
    */
    func getConditionFromJSON(json_ : JSON) -> AnyObject {
        if (json_["list"] != nil) {
            var returnConditionArray = Array<WXCondition>()
            
            for var i = 0; i < json_["list"].count; ++i {
                
                var date: NSDate = NSDate(timeIntervalSince1970: json_["list"][i]["dt"].doubleValue)
                var humidity: Double = json_["list"][i]["main"]["humdity"].doubleValue
                var temperature: Double = json_["list"][i]["main"]["temp"].doubleValue
                var tempHigh: Double = json_["list"][i]["main"]["temp_max"].doubleValue
                var templow: Double = json_["list"][i]["main"]["temp_min"].doubleValue
                var location: String = json_["list"][i]["name"].stringValue
                var sunrise: NSDate = NSDate(timeIntervalSince1970: json_["list"][i]["sys"]["sunrise"].doubleValue)
                var sunset: NSDate = NSDate(timeIntervalSince1970: json_["list"][i]["sys"]["sunset"].doubleValue)
                var description: String = json_["list"][i]["weather"][0]["description"].stringValue
                var condition: String = json_["list"][i]["weather"][0]["main"].stringValue
                var windBearing: Double = json_["list"][i]["wind"]["deg"].doubleValue
                var windSpeed: Double = json_["list"][i]["wind"]["speed"].doubleValue //* MPS_TO_MPH
                var icon: String = json_["list"][i]["weather"][0]["icon"].stringValue
                
                
                // Create WXCondition from the JSON data returned
                returnConditionArray.append(WXCondition(date_: date, humidity_: humidity, temperature_: temperature, tempHigh_: tempHigh, tempLow_: templow, locationName_: location, sunrise_: sunrise, sunset_: sunset, conditionDescription_: description, condition_: condition, windBearing_: windBearing, windSpeed_: windSpeed, icon_: icon))
            }
            
            return returnConditionArray
            
        } else {
            var date: NSDate = NSDate(timeIntervalSince1970: json_["dt"].doubleValue)
            var humidity: Double = json_["main"]["humdity"].doubleValue
            var temperature: Double = json_["main"]["temp"].doubleValue
            var tempHigh: Double = json_["main"]["temp_max"].doubleValue
            var templow: Double = json_["main"]["temp_min"].doubleValue
            var location: String = json_["name"].stringValue
            var sunrise: NSDate = NSDate(timeIntervalSince1970: json_["sys"]["sunrise"].doubleValue)
            var sunset: NSDate = NSDate(timeIntervalSince1970: json_["sys"]["sunset"].doubleValue)
            var description: String = json_["weather"][0]["description"].stringValue
            var condition: String = json_["weather"][0]["main"].stringValue
            var windBearing: Double = json_["wind"]["deg"].doubleValue
            var windSpeed: Double = json_["wind"]["speed"].doubleValue //* MPS_TO_MPH
            var icon: String = json_["weather"][0]["icon"].stringValue
            
            // Create WXCondition from the JSON data returned
            return WXCondition(date_: date, humidity_: humidity, temperature_: temperature, tempHigh_: tempHigh, tempLow_: templow, locationName_: location, sunrise_: sunrise, sunset_: sunset, conditionDescription_: description, condition_: condition, windBearing_: windBearing, windSpeed_: windSpeed, icon_: icon)
        }
    }
    
}
