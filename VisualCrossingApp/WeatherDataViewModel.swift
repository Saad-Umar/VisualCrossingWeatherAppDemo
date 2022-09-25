//
//  WeatherDataViewModel.swift
//  VisualCrossingApp
//
//  Created by Saad Umar on 9/23/22.
//

import Foundation

class WeatherDataViewModel: AppBaseViewModel, ObservableObject {
    @Published var publishedWeatherData:[String:WeatherDataBaseModel]?
    @Published var publishedWeatherDaysData:[String:WeatherDataBaseModel]?
    @Published var publishedWeatherJSONAPIError: Error?
    
    var urlCopenhagem = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/copenhagen%2C%20denmark/2022-08-23/2022-09-23?unitGroup=metric&key=MTVZWQUFG9FB5XS6P8KNJ2NHC&contentType=json"
    var urlLodz = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/Lodz%2C%20Poland?unitGroup=metric&key=MTVZWQUFG9FB5XS6P8KNJ2NHC&contentType=json"
    var urlBrussels = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/Brussels%2C%20Belgium?unitGroup=metric&key=MTVZWQUFG9FB5XS6P8KNJ2NHC&contentType=json"
    var urlIslamabad = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/Islamabad%2C%20Pakistan?unitGroup=metric&key=MTVZWQUFG9FB5XS6P8KNJ2NHC&contentType=json"
    
    @MainActor
    func retrieveWeatherJsonFromServer() {
        Task {
            do {
                let weatherJSON = try await WeatherService().getWeatherData(url:urlCopenhagem)
                let weatherDict = ["copenhagem":weatherJSON]
                let weatherJSON1 = try await WeatherService().getWeatherData(url:urlLodz)
                let weatherDict1 = ["lodz":weatherJSON1]
                let weatherJSON2 = try await WeatherService().getWeatherData(url:urlBrussels)
                let weatherDict2 = ["brussels":weatherJSON2]
                let weatherJSON3 = try await WeatherService().getWeatherData(url:urlIslamabad)
                let weatherDict3 = ["islamabad":weatherJSON3]
                let newJSONWithOnlyDays = weatherDict.merging(weatherDict1){(current, _) in current }.merging(weatherDict2){(current, _) in current }.merging(weatherDict3){(current, _) in current }
                self.publishedWeatherDaysData = newJSONWithOnlyDays

            } catch let parseError {
                print(parseError)
                self.publishedWeatherJSONAPIError = parseError
            }
        }
    }
}

extension Array where Element: Sequence {
    func joined() -> Array<Element.Element> {
        return self.reduce([], +)
    }
}
