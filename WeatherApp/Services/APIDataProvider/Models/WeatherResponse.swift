//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 08.06.2024.
//

import Foundation

struct WeatherResponse: Decodable {
    let id: Int?
    let name: String?
    let coordinate: Coordinate
    let timeZone: TimeZone
    let system: SystemData
    let weather: [WeatherData]
    let main: MainData
    let wind: WindData
    let clouds: CloudsData
    let snow: PrecipitationData?
    let rain: PrecipitationData?
    let visibility: Int
    let date: Date

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case coordinate = "coord"
        case timeZone = "timezone"
        case system = "sys"
        case weather
        case main
        case wind
        case clouds
        case snow
        case rain
        case visibility
        case dateUnix = "dt"
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        self.weather = try container.decode([WeatherData].self, forKey: .weather)
        self.main = try container.decode(MainData.self, forKey: .main)
        self.wind = try container.decode(WindData.self, forKey: .wind)
        self.clouds = try container.decode(CloudsData.self, forKey: .clouds)
        self.snow = try container.decodeIfPresent(PrecipitationData.self, forKey: .snow)
        self.rain = try container.decodeIfPresent(PrecipitationData.self, forKey: .rain)

        let dateUnix = try container.decode(Double.self, forKey: .dateUnix)
        self.date = Date(timeIntervalSince1970: dateUnix)

        self.system = try container.decode(SystemData.self, forKey: .system)

        let timeZoneUnix = try container.decodeIfPresent(Int.self, forKey: .timeZone) ?? 0
        self.timeZone = TimeZone(secondsFromGMT: timeZoneUnix) ?? TimeZone.current
        self.visibility = try container.decode(Int.self, forKey: .visibility)
    }
}

extension WeatherResponse {
    struct PrecipitationData: Decodable {
        let volumeFor1h: Double?
        let volumeFor3h: Double?

        enum CodingKeys: String, CodingKey {
            case volumeFor1h = "1h"
            case volumeFor3h = "3h"
        }
    }

    struct SystemData: Decodable {
        let country: String?
        let timeZone: TimeZone?
        let sunriseDate: Date
        let sunsetDate: Date

        enum CodingKeys: String, CodingKey {
            case country
            case timeZone = "timezone"
            case sunriseUnix = "sunrise"
            case sunsetUnix = "sunset"
        }

        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
            self.country = try container.decodeIfPresent(String.self, forKey: .country)

            let sunriseUnix = try container.decode(Double.self, forKey: .sunriseUnix)
            self.sunriseDate = Date(timeIntervalSince1970: sunriseUnix)

            let sunsetUnix = try container.decode(Double.self, forKey: .sunsetUnix)
            self.sunsetDate = Date(timeIntervalSince1970: sunsetUnix)

            let timeZone = try container.decodeIfPresent(Int.self, forKey: .timeZone) ?? 0
            self.timeZone = TimeZone(secondsFromGMT: timeZone) ?? TimeZone.current
        }
    }
}

