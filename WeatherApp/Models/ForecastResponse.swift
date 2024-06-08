//
//  ForecastResponse.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 08.06.2024.
//

import Foundation

struct ForecastResponse: Codable {
    let count: Int
    let list: [ItemData]
    let city: CityData

    enum CodingKeys: String, CodingKey {
        case count = "cnt"
        case list
        case city
    }
}

extension ForecastResponse {
    struct ItemData: Codable {
        let dateUnix: Int
        let main: MainData
        let weather: [WeatherData]
        let clouds: CloudsData
        let visibility: Int
        let probOfPrecipitation: Double
        let rain: RainData?
        let snow: SnowData?
        let system: SystemData

        enum CodingKeys: String, CodingKey {
            case dateUnix = "dt"
            case main
            case weather
            case clouds
            case visibility
            case probOfPrecipitation = "pop"
            case rain
            case snow
            case system = "sys"
        }
    }

    struct RainData: Codable {
        let volumeFor3h: Double

        enum CodingKeys: String, CodingKey {
            case volumeFor3h = "3h"
        }
    }

    struct SnowData: Codable {
        let volumeFor3h: Double

        enum CodingKeys: String, CodingKey {
            case volumeFor3h = "3h"
        }
    }

    struct SystemData: Codable {
        let partOfDay: String

        enum CodingKeys: String, CodingKey {
            case partOfDay = "pod"
        }
    }

    struct CityData: Codable {
        let id: Int
        let name: String
        let coordinate: Coordinate
        let country: String
        let population: Int
        let timezone: Int
        let sunriseUnix: Int
        let sunsetUnix: Int

        enum CodingKeys: String, CodingKey {
            case id
            case name
            case coordinate = "coord"
            case country
            case population
            case timezone
            case sunriseUnix = "sunrise"
            case sunsetUnix = "sunset"
        }
    }
}
