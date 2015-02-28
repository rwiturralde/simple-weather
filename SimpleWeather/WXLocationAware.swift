//
//  WXLocationAware.swift
//  SimpleWeather
//
//  Created by Roberto Iturralde on 2/26/15.
//  Copyright (c) 2015 Roberto Iturralde. All rights reserved.
//
import Foundation

protocol LocationAware : NSObjectProtocol {
    func onLocationChange() -> Void
}