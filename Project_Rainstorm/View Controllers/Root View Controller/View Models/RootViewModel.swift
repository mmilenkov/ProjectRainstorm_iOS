//
//  RootViewModel.swift
//  Project_Rainstorm
//
//  Created by Miloslav Milenkov on 17/07/2019.
//  Copyright © 2019 Miloslav G. Milenkov. All rights reserved.
//

import Foundation

class RootViewModel: NSObject {
    enum WeatherDataError: Error {
        case noWeatherDataAvailable
        case notAuthorizedForLocationData
        case failedToRequestLocation
    }
    
    enum WeatherDataResult {
        case success(WeatherData)
        case failure(WeatherDataError)
    }
    
    typealias FetchWeatherDataCompletion = (WeatherDataResult) -> Void
    
    var didFetchWeatherData: FetchWeatherDataCompletion?
    
    private let locationService: LocationService
    
    init(locationService: LocationService) {
        self.locationService = locationService
        
        super.init()
        
        fetchWeatherData(for: Defaults.location)
        fetchLocation()
    }
    
    private func fetchWeatherData(for location: Location) {
        let weatherRequest = WeatherRequest(baseURL:WeatherService.authenticatedBaseUrl, location: location)
        
        URLSession.shared.dataTask(with: weatherRequest.url) {
            [weak self] (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print("Status code: \(response.statusCode)")
            }
            
            DispatchQueue.main.async {
                if let error = error {
                    print(error.localizedDescription)
                    self?.didFetchWeatherData?(WeatherDataResult.failure(.noWeatherDataAvailable))
                } else if let data = data {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    
                    do {
                        let response = try decoder.decode(DarkSkyResponse.self, from: data)
                        self?.didFetchWeatherData?(WeatherDataResult.success(response))
                    } catch {
                        print("Failed to parse json")
                        self?.didFetchWeatherData?(WeatherDataResult.failure(.noWeatherDataAvailable))
                    }
                } else {
                    self?.didFetchWeatherData?(WeatherDataResult.failure(.noWeatherDataAvailable))
                }
            }
        }.resume()
        
    }
    
    private func fetchLocation() {
        locationService.fetchLocation {
            [weak self] (result) in
            switch result {
            case .success(let location):
                 self?.fetchWeatherData(for: location)
            case.failure(let error):
                print("\(error)")
                self?.didFetchWeatherData?(WeatherDataResult.failure(.notAuthorizedForLocationData))
            }
        }
        
    }
    
}
