//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 12.06.2024.
//

import Foundation

struct WeatherData: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: Icon

    enum CodingKeys: String, CodingKey {
        case id
        case main
        case description
        case iconID = "icon"
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.main = try container.decode(String.self, forKey: .main)
        self.description = try container.decode(String.self, forKey: .description)

        let iconID = try container.decode(String.self, forKey: .iconID)
        self.icon = Icon(rawValue: iconID) ?? .clearSkyDay
    }
}

extension WeatherData {
    enum Icon: String, Decodable {
        case clearSkyDay = "01d"
        case clearSkyNight = "01n"
        case fewCloudsDay = "02d"
        case fewCloudsNight = "02n"
        case scatteredCloudsDay = "03d"
        case scatteredCloudsNight = "03n"
        case brokenCloudsDay = "04d"
        case brokenCloudsNight = "04n"
        case showerRainDay = "09d"
        case showerRainNight = "09n"
        case rainDay = "10d"
        case rainNight = "10n"
        case thunderstormDay = "11d"
        case thunderstormNight = "11n"
        case snowDay = "13d"
        case snowNight = "13n"
        case mistDay = "50d"
        case mistNight = "50n"

        var sistemName: String {
            switch self {
            case .clearSkyDay: return "sun.max.fill"
            case .clearSkyNight: return "moon.fill"
            case .fewCloudsDay: return "cloud.sun.fill"
            case .fewCloudsNight: return "cloud.moon.fill"
            case .scatteredCloudsDay: return "cloud.fill"
            case .scatteredCloudsNight: return "cloud.fill"
            case .brokenCloudsDay: return "cloud.fill"
            case .brokenCloudsNight: return "cloud.fill"
            case .showerRainDay: return "cloud.heavyrain.fill"
            case .showerRainNight: return "cloud.heavyrain.fill"
            case .rainDay: return "cloud.sun.rain.fill"
            case .rainNight: return "cloud.moon.rain.fill"
            case .thunderstormDay: return "cloud.sun.bolt.fill"
            case .thunderstormNight: return "cloud.moon.bolt.fill"
            case .snowDay: return "snowflake"
            case .snowNight: return "snowflake"
            case .mistDay: return "humidity.fill"
            case .mistNight: return "humidity.fill"
            }
        }
    }
}
