//
//  RootViewModel.swift
//  Project_Rainstorm
//
//  Created by Miloslav Milenkov on 17/07/2019.
//  Copyright © 2019 Miloslav G. Milenkov. All rights reserved.
//

import Foundation

class RootViewModel {
    enum WeatherDataError: Error {
        case noWeatherDataAvailable
    }
    
    typealias DidFetchWeatherDataCompletion = (WeatherData?,WeatherDataError?) -> Void
    
    var didFetchWeatherData: DidFetchWeatherDataCompletion?
    
    init() {
        fetchWeatherData()
    }
    
    private func fetchWeatherData() {
        let weatherRequest = WeatherRequest(baseURL:WeatherService.authenticatedBaseUrl, location: Defaults.location)
        
        URLSession.shared.dataTask(with: weatherRequest.url) {
            [weak self] (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print("Status code: \(response.statusCode)")
            }
            
            DispatchQueue.main.async {
                if let error = error {
                    print(error.localizedDescription)
                    
                    self?.didFetchWeatherData?(nil, .noWeatherDataAvailable)
                } else if let data = data {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    
                    do {
                        let response = try decoder.decode(DarkSkyResponse.self, from: data)
                        self?.didFetchWeatherData?(response,nil)
                    } catch {
                        print("Failed to parse json")
                        self?.didFetchWeatherData?(nil, .noWeatherDataAvailable)
                    }
                } else {
                    self?.didFetchWeatherData?(nil,nil)
                }
            }
        }.resume()
        
    }
    
}
