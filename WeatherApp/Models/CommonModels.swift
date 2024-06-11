//
//  CommonModels.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 08.06.2024.
//

import Foundation

struct MainData: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressureSeaLevel: Int
    let pressureGroundLevel: Int
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressureSeaLevel = "sea_level"
        case pressureGroundLevel = "grnd_level"
        case humidity
    }
}

struct WeatherData: Codable {
    let id: Int
    let main: String
    let description: String
    let iconID: String

    enum CodingKeys: String, CodingKey {
        case id
        case main
        case description
        case iconID = "icon"
    }
}

struct CloudsData: Codable {
    let all: Int
}

struct WindData: Codable {
    let speed: Double
    let degree: Int
    let gust: Double

    enum CodingKeys: String, CodingKey {
        case speed
        case degree = "deg"
        case gust
    }
}

struct Coordinate: Codable {
    let lat: Double
    let lon: Double
}
