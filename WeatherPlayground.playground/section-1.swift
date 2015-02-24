// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
var currentConditionsURL: String = "http://api.openweathermap.org/data/2.5/weather?lat=10&lon=10&units=imperial"
var hourlyConditionsURL: String = "http://api.openweathermap.org/data/2.5/forecast?lat=10&lon=10&units=imperial&cnt=12"


var config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
var session: NSURLSession = NSURLSession(configuration: config)

var dataTask: NSURLSessionDataTask = session.dataTaskWithURL(NSURL(string: currentConditionsURL)!,
    completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
        // Handle data returned from the URL
        if (error == nil) {
            var jsonError: NSError? = nil;
            var json: Dictionary<String, AnyObject>? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as? Dictionary
            
            if ((jsonError == nil) && json != nil) {
                var log = "JSON is \(json)"
            } else {
                NSLog("JSON Error: \(jsonError)")
            }
        } else {
            NSLog("URL Session Error: \(error)")
        }
        
})

dataTask.resume()
