//
//  WeekDayViewModelTests.swift
//  Project_RainstormTests
//
//  Created by Miloslav Milenkov on 18/07/2019.
//  Copyright © 2019 Miloslav G. Milenkov. All rights reserved.
//

import XCTest
@testable import Project_Rainstorm

class WeekDayViewModelTests: XCTestCase {
    
    var viewModel: WeekDayViewModel!

    override func setUp() {
        let data = loadStub(name: "darksky", extension: "json")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let darkSkyResponse = try! decoder.decode(DarkSkyResponse.self, from: data)
        viewModel = WeekDayViewModel(weatherData: darkSkyResponse.forecast[5])
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testDay() {
    XCTAssertEqual(viewModel.day, "Sunday")
    }
    
    func testDate() {
        XCTAssertEqual(viewModel.date, "2 September")
    }
    
    func testTemperature() {
        XCTAssertEqual(viewModel.temperature, "53.9 F - 68.2 F")
    }
    
    func testWindSpeed() {
        XCTAssertEqual(viewModel.windSpeed, "5 MPH")
    }

}
