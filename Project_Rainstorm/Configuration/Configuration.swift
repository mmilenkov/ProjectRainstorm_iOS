//
//  Configuration.swift
//  Project_Rainstorm
//
//  Created by Miloslav Milenkov on 17/07/2019.
//  Copyright © 2019 Miloslav G. Milenkov. All rights reserved.
//

import Foundation

enum Defaults {
    static let location = Location(latitude: 37.335114, longitude: -122.008928, locationName: nil)
}

enum WeatherService {
    private static let apiKey = "e9c296c0ec73ea71cf21fc432c0b5c27"
    private static let baseUrl = URL(string: "https://api.darksky.net/forecast/")!
    static var authenticatedBaseUrl: URL {
        return baseUrl.appendingPathComponent(apiKey)
    }
}

enum Configuration {
    static var refreshThreshold: TimeInterval {
        #if DEBUG
        return 10.0
        #else
        return 10.0 * 60.0
        #endif
    }
}
