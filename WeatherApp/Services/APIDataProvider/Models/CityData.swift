//
//  CityData.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 08.06.2024.
//

import Foundation

struct CityData: Codable {
    let id: Int
    let name: String
    let state: String
    let country: String
    let coordinate: Coordinate

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case state
        case country
        case coordinate = "coord"
    }
}
