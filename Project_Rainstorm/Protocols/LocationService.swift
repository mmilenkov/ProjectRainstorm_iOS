//
//  LocationService.swift
//  Project_Rainstorm
//
//  Created by Miloslav Milenkov on 18/07/2019.
//  Copyright © 2019 Miloslav G. Milenkov. All rights reserved.
//

import Foundation

enum LocationServiceError {
    case notAuthorizedForLocationData
    case unableToFetchDataForLocation
}

enum LocationServiceResult {
    case success(Location)
    case failure(LocationServiceError)
}

protocol LocationService {
    typealias FetchLocationCompletion = (LocationServiceResult) -> Void
    
    func fetchLocation(completion: @escaping FetchLocationCompletion)
    
    func getLocationForName(name location: String, completion: @escaping FetchLocationCompletion)
}
