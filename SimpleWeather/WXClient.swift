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
    
    var session: NSURLSession
    var currentConditionsURL: String = "http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=imperial"
    var hourlyConditionsURL: String = "http://api.openweathermap.org/data/2.5/forecast?lat=%f&lon=%f&units=imperial&cnt=12"
    
    override init() {
        var config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: config)
        super.init()
    }
    
    /**
        Create a signal connecting to the URL provided, that can be subscribed to
        to fetch data from the URL provided. When subscribed, connect to the
    
        :param url The URL to connect to for JSON data
    
        :return A RACSignal to subscribe to for data from the URL endpoint.
    **/
    func fetchJSONFromURL(url: NSURL) -> RACSignal {
        NSLog("Fetching %@", url.absoluteString!)
        
        // Create signal
        return RACSignal.createSignal({ (subscriber: RACSubscriber!) -> RACDisposable! in
            // Create url session data task that connects to URL and fetches data.
            // It hands the fetched data to the completion handler, which is defined on the fly.
            var dataTask: NSURLSessionDataTask = self.session.dataTaskWithURL(url,
                completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
                    // Handle data returned from the URL
                    if (error == nil) {
                        var jsonError: NSError? = nil;
                        var json: Dictionary<String, AnyObject>? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as? Dictionary
                        
                        if ((jsonError == nil) && json != nil) {
                            // send the observer the JSON
                            subscriber.sendNext(json)
                        } else {
                            // notfy the observer of the json parsing error
                            subscriber.sendError(jsonError)
                        }
                    } else {
                        // notfy the observer of the URL session error
                        subscriber.sendError(error)
                    }
                    // notify the observer that the action is complete.
                    subscriber.sendCompleted()
            })
            
            dataTask.resume()
            
            return RACDisposable(block: { () -> Void in
                dataTask.cancel()
            })
            
        // Add a side-effect to the Signal to log any errors
        }) .doError({ (error: NSError!) -> Void in
            NSLog("%@", error)
        })
    }
    
    func fetchCurrentConditionsForLocation(coordinate: CLLocationCoordinate2D) -> RACSignal {
        var urlString: NSString = NSString(format: currentConditionsURL, coordinate.latitude, coordinate.longitude)
        var url: NSURL = NSURL(string: urlString)!
        
        var currentConditionsSignal: RACSignal = fetchJSONFromURL(url)
        
        return currentConditionsSignal.map { (json: AnyObject!) -> WXCondition! in
            let jsonDict = json as? Dictionary<String, AnyObject>
            
            return WXCondition(jsonDict: jsonDict!)
        }
    }
    
    func fetchHourlyForecastForLocation(coordinate: CLLocationCoordinate2D) -> RACSignal {
        var urlString: NSString = NSString(format: hourlyConditionsURL, coordinate.latitude, coordinate.longitude)
        var url: NSURL = NSURL(string: urlString)!

        var hourlyConditionsSignal: RACSignal = fetchJSONFromURL(url)
        
        return hourlyConditionsSignal.map({ (json: AnyObject!) -> AnyObject! in
            let jsonDict = json as? Dictionary<String, AnyObject>

            RACSequence(
            
            var hourlyArray: AnyObject = jsonDict["list"] 
            
            
        })
    }
    
    func fetchDailyForecastForLocation(coordinate: CLLocationCoordinate2D) -> RACSignal {
        
    }
}
