//
//  DayViewModelTests.swift
//  Project_RainstormTests
//
//  Created by Miloslav Milenkov on 17/07/2019.
//  Copyright © 2019 Miloslav G. Milenkov. All rights reserved.
//

import XCTest
@testable import Project_Rainstorm

class DayViewModelTests: XCTestCase {
    
    var viewModel: DayViewModel!

    override func setUp() {
        super.setUp()
        
        let data = loadStub(name: "darksky", extension: "json")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let darkSkyResponse = try! decoder.decode(DarkSkyResponse.self, from: data)
        viewModel = DayViewModel(weatherData: darkSkyResponse.current)
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testDate() {
        XCTAssertEqual(viewModel.date, "Tue, 28 August 2018")
    }
    
    func testTime() {
        XCTAssertEqual(viewModel.time, "04:02 PM")
    }
    
    func testSummary() {
        XCTAssertEqual(viewModel.summary, "Overcast")
    }
    
    func testTemperature() {
        XCTAssertEqual(viewModel.temperature, "57.7 F")
    }
    
    func testWindSpeed() {
        XCTAssertEqual(viewModel.windSpeed, "5 MPH")
    }
}
