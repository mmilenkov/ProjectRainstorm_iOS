//
//  ValueConverter.swift
//  Project_Rainstorm
//
//  Created by Miloslav Milenkov on 18/07/2019.
//  Copyright © 2019 Miloslav G. Milenkov. All rights reserved.
//

import Foundation

class ValueConverter {
    
    static func toKPH(value: Double) -> Double {
        return value * 1.60934
    }
    
    static func toCelsius(value: Double) -> Double {
        return ((value - 32) * 5 / 9)
    }
}
