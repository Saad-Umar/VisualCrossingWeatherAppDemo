//
//  WeatherDataModel.swift
//  VisualCrossingApp
//
//  Created by Saad Umar on 9/23/22.
//


import Foundation

struct WeatherDataBaseModel: Codable, Identifiable {
    
    var id = UUID()
    let success: Bool
    let message: String
    let data: WeatherDataModel
    
    enum CodingKeys: String, CodingKey {
        case success
        case message
        case data
    }
}

struct WeatherDataModel: Codable, Identifiable {
    var id = UUID()
    var temp: String
    
    enum CodingKeys: String, CodingKey {
        case temp
    }
}

