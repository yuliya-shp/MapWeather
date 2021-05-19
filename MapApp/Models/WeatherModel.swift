//
//  WeatherModel.swift
//  MapApp
//
//  
//

import Foundation

struct WeatherModel: Decodable {
    var main: Main
}

struct Main: Decodable {
    var temp: Double
    var pressure: Int
    var humidity: Int
    var temp_min: Double
    var temp_max: Double
    var feels_like: Double
}
