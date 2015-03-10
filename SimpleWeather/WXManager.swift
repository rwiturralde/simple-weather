//
//  WXManager.swift
//  SimpleWeather
//
//  Created by Roberto Iturralde on 2/19/15.
//  Copyright (c) 2015 Roberto Iturralde. All rights reserved.
//

import Foundation
import CoreLocation

class WXManager : NSObject, CLLocationManagerDelegate {
    
    // Set up observer on changes to location
    internal(set) var currentLocation: CLLocation {
        willSet(newLocation) {
            updateCurrentConditions(newLocation)
            updateDailyForecast(newLocation)
            updateHourlyForecast(newLocation)
        }
    }
    
    internal(set) var currentCondition: WXCondition
    internal(set) var hourlyForecast: Array<WXCondition>
    internal(set) var dailyForecast: Array<WXCondition>
    
    internal var locationManager: CLLocationManager
    internal var isFirstUpdate: Bool
    internal var weatherClient: WXClient
    
    var delegate: WeatherDelegate?
    
    override init() {
        currentCondition = WXCondition()
        hourlyForecast = Array()
        dailyForecast = Array()
        currentLocation = CLLocation()
        isFirstUpdate = true
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        weatherClient = WXClient()
        delegate = nil
        super.init()

        locationManager.delegate = self
    }
    
    func updateCurrentConditions(location: CLLocation) -> Void {
        weatherClient.fetchCurrentConditionsForLocation(location.coordinate, handleNewCurrentCondition)
    }
    
    func updateDailyForecast(location: CLLocation) -> Void {
        weatherClient.fetchDailyForecastForLocation(location.coordinate, handleNewDailyForecast)
    }
    
    func updateHourlyForecast(location: CLLocation) -> Void {
        weatherClient.fetchHourlyForecastForLocation(location.coordinate, handleNewHourlyForecast)
    }
    
    
    // Handler for weather condition updates
    func handleNewCurrentCondition(newCondition_ : AnyObject?) -> Void {
        if (newCondition_ != nil) {
            currentCondition = newCondition_ as WXCondition
            
            if (delegate != nil) {
                delegate!.onLocationChange(currentCondition, dailyConditions: dailyForecast, hourlyConditions: hourlyForecast)
            }
        }
    }
    
    // Handler for daily forecast updates
    func handleNewDailyForecast(newForecast_ : AnyObject?) -> Void {
        if (newForecast_ != nil) {
            dailyForecast = newForecast_ as Array<WXCondition>
            
            if (delegate != nil) {
                delegate!.onLocationChange(currentCondition, dailyConditions: dailyForecast, hourlyConditions: hourlyForecast)
            }
        }
    }
    
    // Handler for hourly forecast updates
    func handleNewHourlyForecast(newForecast_ : AnyObject?) -> Void {
        if (newForecast_ != nil) {
            hourlyForecast = newForecast_ as Array<WXCondition>
            
            if (delegate != nil) {
                delegate!.onLocationChange(currentCondition, dailyConditions: dailyForecast, hourlyConditions: hourlyForecast)
            }
        }
    }
    
    
    func findCurrentLocation() -> Void {
        isFirstUpdate = true
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        // Generally returns the last known location in the first update, so ignore.
        /*if (isFirstUpdate) {
            isFirstUpdate = false
            return
        }*/
        
        var location: CLLocation = locations.last as CLLocation
        
        // If we have an accurate location, update our curentLocation and stop updating.
        if (location.horizontalAccuracy > 0) {
            NSLog("Hoizontal accuracy of \(location.horizontalAccuracy). Updating location and stopping location updates")
            currentLocation = location
            locationManager.stopUpdatingLocation()
        } else {
            NSLog("Hoizontal accuracy of \(location.horizontalAccuracy). Ignoring location update")
        }
    }
}