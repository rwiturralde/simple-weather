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
    
    override init() {
        currentCondition = WXCondition()
        hourlyForecast = Array()
        dailyForecast = Array()
        currentLocation = CLLocation()
        isFirstUpdate = true
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        weatherClient = WXClient()

        super.init()

        locationManager.delegate = self
    }
    
    func updateCurrentConditions(location: CLLocation) -> Void {
        currentCondition = weatherClient.fetchCurrentConditionsForLocation(location.coordinate)
    }
    
    func updateDailyForecast(location: CLLocation) -> Void {
        dailyForecast = weatherClient.fetchDailyForecastForLocation(location.coordinate)
    }
    
    func updateHourlyForecast(location: CLLocation) -> Void {
        hourlyForecast = weatherClient.fetchHourlyForecastForLocation(location.coordinate)
    }
    
    func findCurrentLocation() -> Void {
        isFirstUpdate = true
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        // Generally returns the last known location in the first update, so ignore.
        if (isFirstUpdate) {
            isFirstUpdate = false
            return
        }
        
        var location: CLLocation = locations.last as CLLocation
        
        // If we have an accurate location, update our curentLocation and stop updating.
        if (location.horizontalAccuracy > 0) {
            currentLocation = location
            locationManager.stopUpdatingLocation()
        }
    }
}