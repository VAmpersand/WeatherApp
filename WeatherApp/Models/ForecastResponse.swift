//
//  ForecastResponse.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 08.06.2024.
//

import Foundation

struct ForecastResponse: Decodable {
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
    struct ItemData: Decodable {
        let dateUnix: Int
        let main: MainData
        let weather: [WeatherData]
        let clouds: CloudsData
        let visibility: Int
        let probOfPrecipitation: Double
        let rain: PrecipitationData?
        let snow: PrecipitationData?
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

    struct PrecipitationData: Decodable {
        let volumeFor3h: Double

        enum CodingKeys: String, CodingKey {
            case volumeFor3h = "3h"
        }
    }

    struct SystemData: Decodable {
        let partOfDay: String

        enum CodingKeys: String, CodingKey {
            case partOfDay = "pod"
        }
    }

    struct CityData: Decodable {
        let id: Int
        let name: String
        let coordinate: Coordinate
        let country: String
        let population: Int
        let timezone: TimeZone
        let sunriseDate: Date
        let sunsetDate: Date

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

        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(Int.self, forKey: .id)
            self.name = try container.decode(String.self, forKey: .name)
            self.coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
            self.country = try container.decode(String.self, forKey: .country)
            self.population = try container.decode(Int.self, forKey: .population)

            let timezoneValue = try container.decode(Int.self, forKey: .timezone)
            self.timezone = TimeZone(secondsFromGMT: timezoneValue) ?? TimeZone.current

            let sunriseUnix = try container.decode(Double.self, forKey: .sunriseUnix)
            self.sunriseDate = Date(timeIntervalSince1970: sunriseUnix)

            let sunsetUnix = try container.decode(Double.self, forKey: .sunsetUnix)
            self.sunsetDate = Date(timeIntervalSince1970: sunsetUnix)
        }
    }
}
