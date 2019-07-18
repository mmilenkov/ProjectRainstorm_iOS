//
//  MockNetworkService.swift
//  Project_RainstormTests
//
//  Created by Miloslav Milenkov on 18/07/2019.
//  Copyright © 2019 Miloslav G. Milenkov. All rights reserved.
//

import Foundation
@testable import Project_Rainstorm

class MockNetworkService: NetworkService {
    var data: Data?
    var error: Error?
    var statusCode: Int = 200
    
    func fetchData(with url: URL, completionHandler: @escaping NetworkService.FetchDataCompletion) {
        let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)
        completionHandler(data,response,error)
    }
}
