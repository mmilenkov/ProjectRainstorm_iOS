//
//  File.swift
//  Project_RainstormTests
//
//  Created by Miloslav Milenkov on 18/07/2019.
//  Copyright © 2019 Miloslav G. Milenkov. All rights reserved.
//

import Foundation
@testable import Project_Rainstorm

class MockLocationService: LocationService {
    var location: Location? = Location(latitude: 0.0, longitude: 0.0)
    var delay: TimeInterval = 0.0
    func fetchLocation(completion: @escaping LocationService.FetchLocationCompletion) {
        let result: LocationServiceResult
        
        if let location = location {
            result = LocationServiceResult.success(location)
        } else {
            result = LocationServiceResult.failure(.notAuthorizedForLocationData)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion(result)
        }
    }
    
    
}
