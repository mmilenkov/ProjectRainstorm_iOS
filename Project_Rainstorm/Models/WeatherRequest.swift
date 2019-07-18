//
//  WeatherRequest.swift
//  Project_Rainstorm
//
//  Created by Miloslav Milenkov on 17/07/2019.
//  Copyright © 2019 Miloslav G. Milenkov. All rights reserved.
//

import Foundation

struct WeatherRequest {
    let baseURL: URL
    let location: Location
    
    var latitude: Double {
        return location.latitude
    }
    var longitude: Double {
        return location.longitude
    }
    var url: URL {
        return baseURL.appendingPathComponent("\(latitude),\(longitude)")
    }
}
