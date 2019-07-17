//
//  WeatherRequest.swift
//  Project_Rainstorm
//
//  Created by Miloslav Milenkov on 17/07/2019.
//  Copyright © 2019 Miloslav G. Milenkov. All rights reserved.
//

import Foundation
import CoreLocation

struct WeatherRequest {
    let baseURL: URL
    let location: CLLocation
    
    var latitude: Double {
        return location.coordinate.latitude
    }
    var longitude: Double {
        return location.coordinate.longitude
    }
    var url: URL {
        return baseURL.appendingPathComponent("\(latitude),\(longitude)")
    }
}
