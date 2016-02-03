//
//  Location.swift
//  WeatherApp
//
//  Created by Michał Talaga on 26.01.2016.
//  Copyright © 2016 Michal Talaga. All rights reserved.
//

import Foundation

class Location
{
    private var locationID: Int;
    private var name: String;
    private var weatherCondition: String;
    private var windSpeed: String;
    private var actTemperature: Int;
    private var feelTemperature: Int;
    private var timeStamp: Double;
    
    init()
    {
        self.locationID = -1
        self.name = ""
        self.weatherCondition = ""
        self.windSpeed = ""
        self.actTemperature = Int.min
        self.feelTemperature = Int.min
        self.timeStamp = -1.0
    }
        
    func getLocationID() -> Int
    {
        return locationID
    }
    
    func getName() -> String
    {
        return name
    }
    
    func getWeatherCondition() -> String
    {
        return weatherCondition
    }
    
    func getWindSpeed() -> String
    {
        return windSpeed
    }
    
    func getActTemperature() -> Int
    {
        return actTemperature
    }
    
    func getFeelTemperature() -> Int
    {
        return feelTemperature
    }
    
    func getTimeStamp() -> Double
    {
        return timeStamp
    }
    
    func setLocationID(locationID: Int) -> Void
    {
        self.locationID = locationID
    }
    
    func setName(name: String) -> Void
    {
        self.name = name
    }
    
    func setWeatherCondition(weatherCondition: String) -> Void
    {
        self.weatherCondition = weatherCondition
    }
    
    func setWindSpeed(windSpeed: String) -> Void
    {
        self.windSpeed = windSpeed
    }
    
    func setActTemperature(actTemperature: Int) -> Void
    {
        self.actTemperature = actTemperature
    }
    
    func setFeelTemperature(feelTemperature: Int) -> Void
    {
        self.feelTemperature = feelTemperature
    }
    
    func setTimeStamp(timeStamp: Double) -> Void
    {
        self.timeStamp = timeStamp
    }
    
}