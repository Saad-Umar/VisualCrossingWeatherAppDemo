//
//  WeatherService.swift
//
//  Created by Saad Umar on 9/23/22.
//

import Foundation
import UIKit


class WeatherService: AppBaseWebService {
    
    func getWeatherData(url:String) async throws -> WeatherDataBaseModel {
        
        let weatherJsonURL = url
        
        
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
