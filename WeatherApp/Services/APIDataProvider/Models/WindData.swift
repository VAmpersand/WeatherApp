//
//  WindData.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 12.06.2024.
//

import Foundation

struct WindData: Decodable {
    let speed: Double
    let degree: Double
    let gust: Double?

    enum CodingKeys: String, CodingKey {
        case speed
        case degree = "deg"
        case gust
    }
}
