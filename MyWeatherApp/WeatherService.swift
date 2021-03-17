//
//  WeatherService.swift
//  MyWeatherApp
//
//  Created by Erkan Besalti on 2021-03-16.
//

import Foundation
import CoreLocation

public final class WeatherService: NSObject {
    
    private let locationMAnager = CLLocationManager()
    private let API_KEY = "ec2a9ce0818805dc579dbe602d89bf01"
    private var completionHandler: ((WeatherModel) -> Void)?
    
    public override init() {
        super.init()
        locationMAnager.delegate = self
    }
    
    public func loadWeatherData(_ completionHandler: @escaping((WeatherModel) -> Void)) {
        self.completionHandler = completionHandler
        locationMAnager.requestWhenInUseAuthorization()
        locationMAnager.startUpdatingLocation()
    }
    
    private func makeDataRequest(forCoordinates coordinates: CLLocationCoordinate2D) {
        guard let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(API_KEY)&units=metric"
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        guard let url = URL(string: urlString) else {return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data else { return }
            
            if let response = try? JSONDecoder().decode(APIResponse.self, from: data) {
                
                self.completionHandler?(WeatherModel(response: response))
            }
        }.resume()
        
    }
}

extension WeatherService: CLLocationManagerDelegate {
    public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        
        guard let location = locations.first else { return }
        makeDataRequest(forCoordinates: location.coordinate)
    }
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Something went wrong: \(error.localizedDescription)")
    }
}

struct APIResponse: Decodable {
    let name: String
    let main: APIMain
    let weather: [APIWeather]
}

struct  APIMain: Decodable {
    let temp: Double
    
}

struct APIWeather: Decodable {
    let description: String
    let iconName: String
    
    enum CodingKeys: String, CodingKey {
        case description
        case iconName = "main"
        
    }
}
