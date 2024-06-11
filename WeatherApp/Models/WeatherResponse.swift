//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 08.06.2024.
//

import Foundation

struct WeatherResponse: Codable {
    let coordinate: Coordinate
    let weather: [WeatherData]
    let main: MainData
    let wind: WindData
    let clouds: CloudsData
    let snow: SnowData?
    let rain: RainData?
    let dataUnix: Int
    let system: SystemData
    let timezone: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case weather
        case main
        case wind
        case clouds
        case snow
        case rain
        case dataUnix = "dt"
        case system = "sys"
        case timezone
        case name
    }
}

extension WeatherResponse {
    struct RainData: Codable {
        let volumeFor1h: Double?
        let volumeFor3h: Double?

        enum CodingKeys: String, CodingKey {
            case volumeFor1h = "1h"
            case volumeFor3h = "3h"
        }
    }

    struct SnowData: Codable {
        let volumeFor1h: Double?
        let volumeFor3h: Double?

        enum CodingKeys: String, CodingKey {
            case volumeFor1h = "1h"
            case volumeFor3h = "3h"
        }
    }

    struct SystemData: Codable {
        let country: String
        let sunriseUnix: Int
        let sunsetUnix: Int

        enum CodingKeys: String, CodingKey {
            case country
            case sunriseUnix = "sunrise"
            case sunsetUnix = "sunset"
        }
    }
}

