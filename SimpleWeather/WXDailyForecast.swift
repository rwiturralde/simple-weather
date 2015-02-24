//
//  WXDailyForecast.swift
//  SimpleWeather
//
//  Created by Roberto Iturralde on 2/19/15.
//  Copyright (c) 2015 Roberto Iturralde. All rights reserved.
//

import Foundation

class WXDailyForecast : WXCondition {
 
    override internal func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        var paths: Dictionary = super.JSONKeyPathsByPropertyKey()
        
        paths["tempHigh"] = "temp.max"
        paths["tempLow"] = "temp.min"
        
        return paths
    }
}