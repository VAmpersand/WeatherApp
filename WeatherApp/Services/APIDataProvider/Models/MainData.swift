//
//  MainData.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 12.06.2024.
//

import Foundation

struct MainData: Decodable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let pressureGroundLevel: Int?
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case pressureGroundLevel = "grnd_level"
        case humidity
    }
}
