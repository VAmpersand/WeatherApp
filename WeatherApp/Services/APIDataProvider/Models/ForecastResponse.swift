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
        let date: Date
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

        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

            let dateUnix = try container.decode(Double.self, forKey: .dateUnix)
            self.date = Date(timeIntervalSince1970: dateUnix)

            self.main = try container.decode(MainData.self, forKey: .main)
            self.weather = try container.decode([WeatherData].self, forKey: .weather)
            self.clouds = try container.decode(CloudsData.self, forKey: .clouds)
            self.visibility = try container.decode(Int.self, forKey: .visibility)
            self.probOfPrecipitation = try container.decode(Double.self, forKey: .probOfPrecipitation)
            self.rain = try container.decodeIfPresent(ForecastResponse.PrecipitationData.self, forKey: .rain)
            self.snow = try container.decodeIfPresent(ForecastResponse.PrecipitationData.self, forKey: .snow)
            self.system = try container.decode(ForecastResponse.SystemData.self, forKey: .system)
        }
    }

    struct PrecipitationData: Decodable {
        let volumeFor3h: Double

        enum CodingKeys: String, CodingKey {
            case volumeFor3h = "3h"
        }
    }

    struct SystemData: Decodable {
        enum PartOfDay: String, Decodable {
            case day = "d"
            case night = "n"
        }

        let partOfDay: PartOfDay

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
        let timeZone: TimeZone
        let sunriseDate: Date
        let sunsetDate: Date

        enum CodingKeys: String, CodingKey {
            case id
            case name
            case coordinate = "coord"
            case country
            case population
            case timeZone = "timezone"
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

            let timeZoneValue = try container.decode(Int.self, forKey: .timeZone)
            self.timeZone = TimeZone(secondsFromGMT: timeZoneValue) ?? TimeZone.current

            let sunriseUnix = try container.decode(Double.self, forKey: .sunriseUnix)
            self.sunriseDate = Date(timeIntervalSince1970: sunriseUnix)

            let sunsetUnix = try container.decode(Double.self, forKey: .sunsetUnix)
            self.sunsetDate = Date(timeIntervalSince1970: sunsetUnix)
        }
    }
}
