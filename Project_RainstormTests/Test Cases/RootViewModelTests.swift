//
//  RootViewModelTests.swift
//  Project_RainstormTests
//
//  Created by Miloslav Milenkov on 18/07/2019.
//  Copyright © 2019 Miloslav G. Milenkov. All rights reserved.
//

import XCTest
@testable import Project_Rainstorm

class RootViewModelTests: XCTestCase {
    
    var viewModel: RootViewModel!
    var locationService: MockLocationService!
    var networkService: MockNetworkService!

    override func setUp() {
        super.setUp()
        networkService = MockNetworkService()
        let data = loadStub(name: "darksky", extension: "json")
        networkService.data = data
        
        locationService = MockLocationService()
        
        viewModel = RootViewModel(locationService: locationService, networkService: networkService)
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "didFetchWeatherData")
        super.tearDown()
    }
    
    func testRefresh_Success() {
        let expectation = XCTestExpectation(description: "Fetch Weather Data")
        
        viewModel.didFetchWeatherData = {
            (result) in
            if case .success(let weatherData) =  result {
                XCTAssertEqual(weatherData.latitude, 37.8267)
                XCTAssertEqual(weatherData.longitude, -122.4233)
                expectation.fulfill()
            }
        }
        viewModel.refresh()
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testRefresh_FailedToFetchLocation() {
        locationService.location = nil
        
        let expectation = XCTestExpectation(description: "Fetch Weather Data")
        
        viewModel.didFetchWeatherData = {
            (result) in
            if case .failure(let error) =  result {
                XCTAssertEqual(error, RootViewModel.WeatherDataError.notAuthorizedForLocationData)
                expectation.fulfill()
            }
        }
        viewModel.refresh()
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testRefresh_FailedToFetchData_RequestFailed() {
        networkService.error = NSError(domain: "com.musala.com.network.service", code: 1, userInfo: nil)
        let expectation = XCTestExpectation(description: "Fetch Weather Data")
        
        viewModel.didFetchWeatherData = {
            (result) in
            if case .failure(let error) =  result {
                XCTAssertEqual(error, RootViewModel.WeatherDataError.noWeatherDataAvailable)
                expectation.fulfill()
            }
        }
        viewModel.refresh()
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testRefresh_FailedToFetchData_InvalidResponse() {
        networkService.data = "data".data(using: .utf8)
        let expectation = XCTestExpectation(description: "Fetch Weather Data")
        
        viewModel.didFetchWeatherData = {
            (result) in
            if case .failure(let error) =  result {
                XCTAssertEqual(error, RootViewModel.WeatherDataError.noWeatherDataAvailable)
                expectation.fulfill()
            }
        }
        viewModel.refresh()
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testRefresh_FailedToFetchData_NoErrorNoResponse() {
        networkService.data = nil
        let expectation = XCTestExpectation(description: "Fetch Weather Data")
        
        viewModel.didFetchWeatherData = {
            (result) in
            if case .failure(let error) =  result {
                XCTAssertEqual(error, RootViewModel.WeatherDataError.noWeatherDataAvailable)
                expectation.fulfill()
            }
        }
        viewModel.refresh()
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testApplicationWillEnterForeground_NoTimestamp() {
        UserDefaults.standard.removeObject(forKey: "didFetchWeatherData")
        let expectation = XCTestExpectation(description: "Fetch Weather Data")
        
        viewModel.didFetchWeatherData = {
            (result) in
                expectation.fulfill()
        }
        
        NotificationCenter.default.post(name: .NSExtensionHostWillEnterForeground, object: nil)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testApplicationWillEnterForeground_ShouldRefresh() {
        UserDefaults.standard.set(Date().addingTimeInterval(-3600.0), forKey: "didFetchWeatherData")
        let expectation = XCTestExpectation(description: "Fetch Weather Data")
        
        viewModel.didFetchWeatherData = {
            (result) in
            expectation.fulfill()
        }
        
        NotificationCenter.default.post(name: .NSExtensionHostWillEnterForeground, object: nil)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testApplicationWillEnterForeground_ShouldNotRefresh() {
        UserDefaults.standard.set(Date(), forKey: "didFetchWeatherData")
        let expectation = XCTestExpectation(description: "Fetch Weather Data")
        expectation.isInverted = true
        
        viewModel.didFetchWeatherData = {
            (result) in
            expectation.fulfill()
        }
        
        NotificationCenter.default.post(name: .NSExtensionHostWillEnterForeground, object: nil)
        
        wait(for: [expectation], timeout: 2.0)
    }

}
