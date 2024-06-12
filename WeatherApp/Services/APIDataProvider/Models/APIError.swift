//
//  ErrorResponse.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 12.06.2024.
//

import Foundation

struct APIError: Decodable {
    let code: Int
    let message: String

    enum CodingKeys: String, CodingKey {
        case code = "cod"
        case message
    }
}
