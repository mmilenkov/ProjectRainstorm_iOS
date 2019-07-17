//
//  XCTestCase.swift
//  Project_RainstormTests
//
//  Created by Miloslav Milenkov on 17/07/2019.
//  Copyright © 2019 Miloslav G. Milenkov. All rights reserved.
//

import XCTest

extension XCTestCase {
    func loadStub(name: String, extension: String) -> Data {
        let bundle = Bundle(for:classForCoder)
        let url = bundle.url(forResource: name, withExtension: `extension`)
        
        return try! Data(contentsOf: url!)
    }
}
