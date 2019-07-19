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
            didFetchLocation?(LocationServiceResult.failure(.notAuthorizedForLocationData))
            didFetchLocation = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        didFetchLocation?(LocationServiceResult.success(Location(location: location)))
        didFetchLocation = nil
    }
}

fileprivate extension Location {
    init(location: CLLocation) {
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }
}

extension LocationManager {
    
    func getLocationForName(name location: String, completion: @escaping LocationManager.FetchLocationCompletion){
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(location) {
            [weak self] placemarks, error in
            self?.didFetchLocation = completion
            guard error == nil else {
                self?.didFetchLocation?(LocationServiceResult.failure(.unableToFetchDataForLocation))
                return
            }
            
            guard let placemark = placemarks?[0] else {
                self?.didFetchLocation?(LocationServiceResult.failure(.unableToFetchDataForLocation))
                return
            }
            
            guard let location = placemark.location else {
                self?.didFetchLocation?(LocationServiceResult.failure(.unableToFetchDataForLocation))
                return
            }
            
            self?.didFetchLocation?(LocationServiceResult.success(Location(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)))
            }
    }
}
