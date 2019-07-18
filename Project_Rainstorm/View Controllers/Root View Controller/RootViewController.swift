//
//  RootViewController.swift
//  Project_Rainstorm
//
//  Created by Miloslav Milenkov on 17/07/2019.
//  Copyright © 2019 Miloslav G. Milenkov. All rights reserved.
//

import UIKit

final class RootViewController: UIViewController {
    
    private enum AlertType {
        case notAuthorizedForLocationData
        case noWeatherDataAvailable
        case failedToRequestLocation
    }
    
    var viewModel: RootViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            setupViewModel(with: viewModel)
        }
    }
    
    private let dayViewController: DayViewController = {
        guard let dayViewController = UIStoryboard.main.instantiateViewController(withIdentifier: DayViewController.storyboardIdentifier) as? DayViewController else {
            fatalError("Unable to instantiate Day View Controller")
        }
        dayViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return dayViewController
    }()
    
    private let weekViewController: WeekViewController = {
        guard let weekViewController = UIStoryboard.main.instantiateViewController(withIdentifier: WeekViewController.storyboardIdentifier) as? WeekViewController else {
            fatalError("Unable to instantiate Week View Controller")
        }
        weekViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return weekViewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupChildViewControllers()
    }
    
    private func setupChildViewControllers() {
        addChild(dayViewController)
        addChild(weekViewController)
        
        view.addSubview(dayViewController.view)
        view.addSubview(weekViewController.view)
        
        dayViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        dayViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        dayViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        weekViewController.view.topAnchor.constraint(equalTo: dayViewController.view.bottomAnchor).isActive = true
        weekViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        weekViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        weekViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        dayViewController.didMove(toParent: self)
        weekViewController.didMove(toParent: self)
    }
    
    private func setupViewModel(with viewModel: RootViewModel) {
        viewModel.didFetchWeatherData = {
            [weak self] (weatherData, error) in
            if let error = error {
                let alertType: AlertType
                switch error {
                case .notAuthorizedForLocationData:
                    alertType = .notAuthorizedForLocationData
                case .noWeatherDataAvailable:
                    alertType = .noWeatherDataAvailable
                case .failedToRequestLocation:
                    alertType = .failedToRequestLocation
                }
                
                self?.presentAlert(of: alertType)
            } else if let weatherData = weatherData {
                let dayViewModel = DayViewModel(weatherData: weatherData.current)
                self?.dayViewController.viewModel = dayViewModel
                
                let weekViewModel = WeekViewModel(weatherData: weatherData.forecast)
                self?.weekViewController.viewModel = weekViewModel
            }
        }
    }
    
    private func presentAlert(of alertType: AlertType) {
        let title: String
        let message: String
        switch alertType {
        case .noWeatherDataAvailable:
            title = "Unable to Fetch Weather Data"
            message = "The application is unable to fetch weather data. Please make sure your device is connected over Wi-Fi or cellular."
        case .notAuthorizedForLocationData:
            title = "Unable to Fetch Weather Data For Your Location"
            message = "You have not granted permission for the application to use your Location. A default location will be displayed. You can access to your current location in the Settings application"
        case .failedToRequestLocation:
            title = "Unable to Request Location"
            message = "The application is unable to fetch your location due to a technical issue"
        }
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac, animated: true)
    }

}
