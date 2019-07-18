//
//  NetworkService.swift
//  Project_Rainstorm
//
//  Created by Miloslav Milenkov on 18/07/2019.
//  Copyright © 2019 Miloslav G. Milenkov. All rights reserved.
//

import Foundation

protocol NetworkService {
    typealias FetchDataCompletion = (Data?,URLResponse?,Error?) -> Void
    
    func fetchData(with url: URL, completionHandler: @escaping FetchDataCompletion)
}
