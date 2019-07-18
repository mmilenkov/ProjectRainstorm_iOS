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
    private let networkService: NetworkService
    
    init(locationService: LocationService, networkService: NetworkService) {
        self.locationService = locationService
        self.networkService = networkService
        super.init()
        setupNotificationHandling()
    }
    
    private func fetchWeatherData(for location: Location) {
        let weatherRequest = WeatherRequest(baseURL:WeatherService.authenticatedBaseUrl, location: location)
        networkService.fetchData(with: weatherRequest.url) {
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
                        
                        UserDefaults.didFetchWeatherData = Date()
                        
                        self?.didFetchWeatherData?(WeatherDataResult.success(response))
                    } catch {
                        print("Failed to parse json")
                        self?.didFetchWeatherData?(WeatherDataResult.failure(.noWeatherDataAvailable))
                    }
                } else {
                    self?.didFetchWeatherData?(WeatherDataResult.failure(.noWeatherDataAvailable))
                }
            }
        }
        
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
    
    private func setupNotificationHandling() {
        NotificationCenter.default
            .addObserver(forName: .NSExtensionHostWillEnterForeground, object: nil, queue: OperationQueue.main) {
                [weak self] (_) in
                guard let didFetchWeatherData = UserDefaults.didFetchWeatherData else {
                    self?.refresh()
                    return
                }
                
                if Date().timeIntervalSince(didFetchWeatherData) > Configuration.refreshThreshold {
                    self?.refresh()
                }
            }
}
    
    func refresh() {
        fetchLocation()
    }
    
}

extension UserDefaults {
    private enum Keys {
        static let didFetchWeatherData = "didFetchWeatherData"
    }
    
    fileprivate class var didFetchWeatherData: Date? {
        get {
            return UserDefaults.standard.object(forKey: Keys.didFetchWeatherData) as? Date
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: Keys.didFetchWeatherData)
        }
    }
}
