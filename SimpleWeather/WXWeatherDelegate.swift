//
//  WXWeatherDelegate.swift
//  SimpleWeather
//
//  Created by Roberto Iturralde on 2/26/15.
//  Copyright (c) 2015 Roberto Iturralde. All rights reserved.
//

protocol WeatherDelegate {
    func onLocationChange(currentCondition: WXCondition, dailyConditions: Array<WXCondition>, hourlyConditions: Array<WXCondition>)
}