//
//  WeatherDataViewModel.swift
//  VisualCrossingApp
//
//  Created by Saad Umar on 9/23/22.
//

import Foundation

class WeatherDataViewModel: AppBaseViewModel, ObservableObject {
    
    @Published var publishedWeatherData:WeatherDataBaseModel?
    @Published var publishedWeatherJSONAPIError: Error?
    
    @MainActor
    func retrieveWeatherJsonFromServer() {
        Task {
            do {
                let weatherJSON = try await WeatherService().getWeatherData()
                
                self.publishedWeatherData = weatherJSON

            } catch let parseError {
                print(parseError)
                self.publishedWeatherJSONAPIError = parseError
            }
        }
    }
}
