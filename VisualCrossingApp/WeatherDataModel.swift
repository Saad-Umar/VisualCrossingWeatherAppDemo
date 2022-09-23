//
//  WeatherDataModel.swift
//  VisualCrossingApp
//
//  Created by Saad Umar on 9/23/22.
//


import Foundation

struct WeatherDataBaseModel: Codable, Identifiable {
    
    var id = UUID()
    let days: [WeatherDataModel]
    
    enum CodingKeys: String, CodingKey {
        case days
    }
}

struct WeatherDataModel: Codable, Identifiable {
    var id = UUID()
    let datetime: String
    let datetimeEpoch: Int
    let temp, feelslike, humidity, dew: Double
    let precip: Double
    let precipprob: Double?
    let snow, snowdepth: Int
    let preciptype: [String]?
    let windgust: Double?
    let windspeed, winddir, pressure, visibility: Double

    enum CodingKeys: String, CodingKey {
        case datetime, datetimeEpoch, temp, feelslike, humidity, dew, precip, precipprob, snow, snowdepth, preciptype, windgust, windspeed, winddir, pressure, visibility
    }
}
