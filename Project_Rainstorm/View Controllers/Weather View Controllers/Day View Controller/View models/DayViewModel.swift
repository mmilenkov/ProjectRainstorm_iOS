//
//  DayViewModel.swift
//  Project_Rainstorm
//
//  Created by Miloslav Milenkov on 17/07/2019.
//  Copyright © 2019 Miloslav G. Milenkov. All rights reserved.
//

import Foundation
import UIKit

struct DayViewModel {
    let weatherData: CurrentWeatherConditions
    
    private let dateFormatter = DateFormatter()
    
    var date: String {
        dateFormatter.dateFormat = "EEE, d MMMM YYYY"
        return dateFormatter.string(from: weatherData.time)
    }
    
    var time: String {
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: weatherData.time)
    }
    
    var summary: String {
        return weatherData.summary
    }
    
    var temperature: String {
        return String(format: "%.1f °C", ValueConverter.toCelsius(value: weatherData.temperature))
    }
    
    var windSpeed: String {
        return String(format: "%.f KPH", ValueConverter.toKPH(value: weatherData.windSpeed))
    }
    
    var image: UIImage? {
        return UIImage.imageForIcon(with: weatherData.icon)
    }
}
