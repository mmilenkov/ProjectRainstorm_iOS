//
//  RootViewModel.swift
//  Project_Rainstorm
//
//  Created by Miloslav Milenkov on 17/07/2019.
//  Copyright © 2019 Miloslav G. Milenkov. All rights reserved.
//

import Foundation
import CoreLocation

class RootViewModel: NSObject {
    enum WeatherDataError: Error {
        case noWeatherDataAvailable
        case notAuthorizedForLocationData
    }
    
    typealias DidFetchWeatherDataCompletion = (WeatherData?,WeatherDataError?) -> Void
    
    var didFetchWeatherData: DidFetchWeatherDataCompletion?
    
    private lazy var locationManager: CLLocationManager = {
    let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
        
    }()
    
    override init() {
        super.init()
        fetchWeatherData(for: Defaults.location)
        
        fetchLocation()
    }
    
    private func fetchWeatherData(for location: CLLocation) {
        let weatherRequest = WeatherRequest(baseURL:WeatherService.authenticatedBaseUrl, location: location)
        
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
    
    private func fetchLocation() {
        locationManager.requestLocation()
        
    }
    
}

extension RootViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location failed")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse {
            fetchLocation()
        } else {
            didFetchWeatherData?(nil, .notAuthorizedForLocationData)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        fetchWeatherData(for: location)
    }
    
}
