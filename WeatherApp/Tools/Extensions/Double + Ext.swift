//
//  Double + Ext.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 12.06.2024.
//

import Foundation

extension Double {
    func formatedTemp() -> String {
        let roundedTemp = self.rounded()
        return String(format: "%g", roundedTemp) + "º"
    }
}
