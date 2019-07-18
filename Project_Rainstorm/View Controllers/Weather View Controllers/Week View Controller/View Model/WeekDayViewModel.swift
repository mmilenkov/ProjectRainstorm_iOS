//
//  WeekDayViewModel.swift
//  Project_Rainstorm
//
//  Created by Miloslav Milenkov on 18/07/2019.
//  Copyright © 2019 Miloslav G. Milenkov. All rights reserved.
//

import UIKit

struct WeekDayViewModel {
    
    let weatherData: ForecastWeatherConditions
    
    private let dateFormatter = DateFormatter()
    
    var day: String {
        dateFormatter.dateFormat = "EEEE"
        
        return dateFormatter.string(from: weatherData.time)
    }
    
    var date: String {
        dateFormatter.dateFormat = "d MMMM"
        
        return dateFormatter.string(from: weatherData.time)
    }
    
    var temperature: String {
        let min = String(format: "%.1f °C", ValueConverter.toCelsius(value: weatherData.temperatureMin))
        let max = String(format: "%.1f °C", ValueConverter.toCelsius(value: weatherData.temperatureMax))
        return "\(min) - \(max)"
    }
    
    var windSpeed: String {
        return String(format: "%.f KPH", ValueConverter.toKPH(value: weatherData.windSpeed))
    }
    
    var image: UIImage? {
        return UIImage.imageForIcon(with: weatherData.icon)
    }
    
}

extension WeekDayViewModel: WeekDayRepresentable {
    
}
