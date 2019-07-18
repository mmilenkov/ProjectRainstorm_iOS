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
}

protocol LocationService {
    typealias FetchLocationCompletion = (Location?, LocationServiceError?) -> Void
    
    func fetchLocation(completion: @escaping FetchLocationCompletion)
}
