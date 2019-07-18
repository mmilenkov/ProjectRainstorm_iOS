//
//  WeekViewModelTests.swift
//  Project_RainstormTests
//
//  Created by Miloslav Milenkov on 18/07/2019.
//  Copyright © 2019 Miloslav G. Milenkov. All rights reserved.
//

import XCTest
@testable import Project_Rainstorm

class WeekViewModelTests: XCTestCase {
    
    var viewModel: WeekViewModel!

    override func setUp() {
        
        let data = loadStub(name: "darksky", extension: "json")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let darkSkyResponse = try! decoder.decode(DarkSkyResponse.self, from: data)
        
        viewModel = WeekViewModel(weatherData: darkSkyResponse.forecast)
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testNumberOfDays() {
        XCTAssertEqual(viewModel.numberOfDays, 8)
    }
    
    func testViewModelForIndex() {
        let weekDayViewModel = viewModel.viewModel(for: 5)
        
        XCTAssertEqual(weekDayViewModel.day, "Sunday")
        XCTAssertEqual(weekDayViewModel.date, "2 September")
    }

}
