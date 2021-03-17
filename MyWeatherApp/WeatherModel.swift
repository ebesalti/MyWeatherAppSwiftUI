//
//  WeatherModel.swift
//  MyWeatherApp
//
//  Created by Erkan Besalti on 2021-03-16.
//

import Foundation

public struct WeatherModel {
    let city: String
    let temperature: String
    let description: String
    let iconName: String
    
    init(response: APIResponse) {
        city = response.name
        temperature = "\(Int(response.main.temp))"
        description = response.weather.first?.description ?? ""
        iconName = response.weather.first?.iconName ?? ""
    }
}
