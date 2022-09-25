//
//  ContentView.swift
//  VisualCrossingApp
//
//  Created by Saad Umar on 9/23/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = WeatherDataViewModel()
    var body: some View {
        Text("Hello, world!")
            .padding()
        SwiftUI.Color.blue
            .ignoresSafeArea()
            .overlay(
                
                List {
                    Section(header: Text("copenhagem")) {
                        ForEach(viewModel.publishedWeatherDaysData?["copenhagem"]?.days ?? []) { day in
                            Text("\(day.temp)")
                                .padding()
                        }
                    }
                    Section(header: Text("lodz")) {
                        ForEach(viewModel.publishedWeatherDaysData?["lodz"]?.days ?? []) { day in
                            Text("\(day.temp)")
                                .padding()
                        }
                    }
                    Section(header: Text("brussels")) {
                        ForEach(viewModel.publishedWeatherDaysData?["brussels"]?.days ?? []) { day in
                            Text("\(day.temp)")
                                .padding()
                        }
                    }
                    Section(header: Text("islamabad")) {
                        ForEach(viewModel.publishedWeatherDaysData?["islamabad"]?.days ?? []) { day in
                            Text("\(day.temp)")
                                .padding()
                        }
                    }
                    
                }
                    .onAppear(perform:  viewModel.retrieveWeatherJsonFromServer)
                    .frame(width: .infinity, height: .infinity)
                    .listStyle(.plain)
                
                //.listRowSeparatorTint(.white) //For iOS 15 or higher only)
            )
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
