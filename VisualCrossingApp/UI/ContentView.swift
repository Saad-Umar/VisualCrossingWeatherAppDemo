//
//  ContentView.swift
//  VisualCrossingApp
//
//  Created by Saad Umar on 9/23/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = WeatherDataViewModel()
    @State var range: Range<Int> = 0..<1
    var dataFetching:Bool {
        if viewModel.publishedWeatherDaysData?.count ?? 0 == 0 {
            return true
        } else {
            return false
        }
    }
    var body: some View {
        Text("Hello, world!")
            .padding()
        SwiftUI.Color.white
            .ignoresSafeArea()
            .overlay(
                /*
                 city wind_avg wind_median temp_avg temp_median
                 city_name 4.7 4.2 54.8 53.6
                 */
                
                List {
                    Section(header: Text("copenhagem")) {
                        
                        ForEach(range) { day in
                            let avgsAndMeds = viewModel.publishedWeatherDaysData?["copenhagem"]
                            HStack{
                                VStack {
                                    Text("wind_avg")
                                    Text(avgsAndMeds?.averageWind ?? "")
                                }
                                VStack {
                                    Text("wind_med")
                                    Text(avgsAndMeds?.medianWind ?? "")
                                }
                                VStack {
                                    Text("temp_avg")
                                    Text(avgsAndMeds?.averageTemp ?? "")
                                }
                                VStack {
                                    Text("temp_med")
                                    Text(avgsAndMeds?.medianTemp ?? "")
                                }
                            }
                            .padding()
                        }
                    }
                    Section(header: Text("lodz")) {
                        ForEach(range) { day in
                            let avgsAndMeds = viewModel.publishedWeatherDaysData?["lodz"]
                            HStack{
                                VStack {
                                    Text("wind_avg")
                                    Text(avgsAndMeds?.averageWind ?? "")
                                }
                                VStack {
                                    Text("wind_med")
                                    Text(avgsAndMeds?.medianWind ?? "")
                                }
                                VStack {
                                    Text("temp_avg")
                                    Text(avgsAndMeds?.averageTemp ?? "")
                                }
                                VStack {
                                    Text("temp_med")
                                    Text(avgsAndMeds?.medianTemp ?? "")
                                }
                            }
                            .padding()
                        }
                    }
                    Section(header: Text("brussels")) {
                        ForEach(range) { day in
                            let avgsAndMeds = viewModel.publishedWeatherDaysData?["brussels"]
                            HStack{
                                VStack {
                                    Text("wind_avg")
                                    Text(avgsAndMeds?.averageWind ?? "")
                                }
                                VStack {
                                    Text("wind_med")
                                    Text(avgsAndMeds?.medianWind ?? "")
                                }
                                VStack {
                                    Text("temp_avg")
                                    Text(avgsAndMeds?.averageTemp ?? "")
                                }
                                VStack {
                                    Text("temp_med")
                                    Text(avgsAndMeds?.medianTemp ?? "")
                                }
                            }
                            .padding()
                        }
                    }
                    Section(header: Text("islamabad")) {
                        ForEach(range) { day in
                            let avgsAndMeds = viewModel.publishedWeatherDaysData?["islamabad"]
                            HStack{
                                VStack {
                                    Text("wind_avg")
                                    Text(avgsAndMeds?.averageWind ?? "")
                                }
                                VStack {
                                    Text("wind_med")
                                    Text(avgsAndMeds?.medianWind ?? "")
                                }
                                VStack {
                                    Text("temp_avg")
                                    Text(avgsAndMeds?.averageTemp ?? "")
                                }
                                VStack {
                                    Text("temp_med")
                                    Text(avgsAndMeds?.medianTemp ?? "")
                                }
                            }
                            .padding()
                        }
                    }
                    
                }
                    .overlay(Group {
                           if dataFetching {
                               ProgressView()
                                   .scaleEffect(x: 4, y: 4, anchor: .center)
                           }
                        })
                    .onAppear(perform:  viewModel.retrieveWeatherJsonFromServer)
                    .onAppear(perform: updateRange)
                    .frame(width: .infinity, height: .infinity)
                    .listStyle(.plain)
                
            )
        
    }
    
    func updateRange() {
        range = 0..<(viewModel.publishedWeatherDaysData?.count ?? 0)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
