//
//  UIImage.swift
//  Project_Rainstorm
//
//  Created by Miloslav Milenkov on 17/07/2019.
//  Copyright © 2019 Miloslav G. Milenkov. All rights reserved.
//

import UIKit

extension UIImage {
    class func imageForIcon(with name: String) -> UIImage? {
        switch name {
            case "clear-day",
                 "clear-night",
                 "fog",
                 "rain",
                 "snow",
                 "sleet",
                 "wind" :
            return UIImage(named: name)
        case "cloudy",
             "partly-cloudy-day",
             "partly-cloudy-night" :
            return UIImage(named: "cloudy")
        default:
            return UIImage(named: "clear-day")
            
        }
    }
}
