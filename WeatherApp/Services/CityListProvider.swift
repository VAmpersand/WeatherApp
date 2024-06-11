//
//  CityListProvider.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 08.06.2024.
//

import Foundation

protocol CityListProvider {
    var cityList: [CityData] { get }
}

final class CityListProviderImpl: CityListProvider {
    var cityList: [CityData] = []

    init() {
        guard let path = Bundle.main.path(forResource: "city_list", ofType: "json"),
              let data = FileManager.default.contents(atPath: path) else {
            fatalError("city_list.json not found")
        }

        let decoder = JSONDecoder()

        cityList = try! decoder.decode([CityData].self, from: data)
    }
}
