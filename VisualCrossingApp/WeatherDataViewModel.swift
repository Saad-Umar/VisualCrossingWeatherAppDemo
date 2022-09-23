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
    
    // TODO: This needs to be passed by the retrieveWeatherJsonFromServer caller, currently putting here due to a SwiftUI bug
    var urlCopenhagem = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/copenhagen%2C%20denmark/2022-08-23/2022-09-23?unitGroup=metric&key=MTVZWQUFG9FB5XS6P8KNJ2NHC&contentType=json"
    
    @MainActor
    func retrieveWeatherJsonFromServer() {
        Task {
            do {
                let weatherJSON = try await WeatherService().getWeatherData(url:urlCopenhagem)
                
                self.publishedWeatherData = weatherJSON

            } catch let parseError {
                print(parseError)
                self.publishedWeatherJSONAPIError = parseError
            }
        }
    }
}
