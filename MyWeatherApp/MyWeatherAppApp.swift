//
//  MyWeatherAppApp.swift
//  MyWeatherApp
//
//  Created by Erkan Besalti on 2021-03-16.
//

import SwiftUI

@main
struct MyWeatherAppApp: App {
    var body: some Scene {
        WindowGroup {
            let weatherService = WeatherService()
            let viewModel = WeatherViewModel(weatherService: weatherService)
            WeatherView(viewModel: viewModel)
        }
    }
}

