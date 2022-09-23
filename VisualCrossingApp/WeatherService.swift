//
//  WeatherService.swift
//
//  Created by Saad Umar on 9/23/22.
//

import Foundation
import UIKit


class WeatherService: AppBaseWebService {
    
    func getWeatherData() async throws -> WeatherDataBaseModel {
        
        let weatherJsonURL = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/copenhagen%2C%20denmark/2022-08-23/2022-09-23?unitGroup=metric&key=MTVZWQUFG9FB5XS6P8KNJ2NHC&contentType=json"
        
        
        do {
            let weather = try await AppWebService(ignoreDefaultHeaders: false)
                                      .setURL(url: weatherJsonURL)
                                      .makeRequest(type: WeatherDataBaseModel.self)
            let data = weather
            return data
        } catch {
            throw error
        }
    }
    
}
