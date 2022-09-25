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
    
    var averageTemp:String {
        let sumArray = days.reduce(0) { partialResult, model in
            partialResult + model.temp
        }
        let count = days.count
        let avg = sumArray / Double(count)
        
        return "\(round(avg, to: 4))"
    }
    
    var medianTemp:String {
        let temps = days.map { Double($0.temp) }
        return "\(calculateMedian(array: temps))"
    }
    
    var averageWind:String {
        let sumArray = days.reduce(0) { partialResult, model in
            partialResult + model.windspeed
        }
        let count = days.count
        let avg = sumArray / Double(count)
        
        return "\(round(avg, to: 4))"
    }
    
    var medianWind:String {
        let winds = days.map { Double($0.windspeed) }
        return "\(calculateMedian(array: winds))"
    }
    
    enum CodingKeys: String, CodingKey {
        case days
    }
    
    //TODO: Better to create and Array extension rather then a member function of current struct
    
    private func calculateMedian(array: [Double]) -> Double {
        let sorted = array.sorted()
        if sorted.count % 2 == 0 {
            return round((Double((sorted[(sorted.count / 2)] + sorted[(sorted.count / 2) - 1])) / 2), to: 4)
        } else {
            return round(Double(sorted[(sorted.count - 1) / 2]), to: 4)
        }
    }
    
    private func round(_ num: Double, to places: Int) -> Double {
        let p = log10(abs(num))
        let f = pow(10, p.rounded() - Double(places) + 1)
        let rnum = (num / f).rounded() * f

        return rnum
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

