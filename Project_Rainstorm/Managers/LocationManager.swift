//
//  LocationManager.swift
//  Project_Rainstorm
//
//  Created by Miloslav Milenkov on 18/07/2019.
//  Copyright © 2019 Miloslav G. Milenkov. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, LocationService {
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
        
    }()
    
    private var didFetchLocation: FetchLocationCompletion?
    
    func fetchLocation(completion: @escaping LocationManager.FetchLocationCompletion) {
        didFetchLocation = completion
        
        locationManager.requestLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location failed")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        } else {
            didFetchLocation?(nil, .notAuthorizedForLocationData)
            didFetchLocation = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        didFetchLocation?(Location(location: location),nil)
        didFetchLocation = nil
    }
}

fileprivate extension Location {
    init(location: CLLocation) {
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }
}
