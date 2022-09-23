//
//  WeatherService.swift
//
//  Created by Saad Umar on 9/23/22.
//

import Foundation
import UIKit


class WeatherService: AppBaseWebService {
    
    func getWeatherData() async throws -> WeatherDataModel {
        
        let weatherJsonURL = ""
        
        
        do {
            let team = try await AppWebService(ignoreDefaultHeaders: false)
                                      .setURL(url: weatherJsonURL)
                                      .makeRequest(type: WeatherDataBaseModel.self)
            let data = team.data
            return data
        } catch {
            throw error
        }
    }
    
}
