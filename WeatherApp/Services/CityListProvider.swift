//
//  CityListProvider.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 08.06.2024.
//

import Foundation

protocol CityListProvider {
    var cityList: [CityData] { get }
    var selectedCityList: [CityData] { get }
}

final class CityListProviderImpl: CityListProvider {
    private let storageManager = UDStorageManager()
    private var currentPlaceCoord = Coordinate(lat: -20.563568, lon: -50.578311)

    var cityList: [CityData] = []
    var selectedCityList: [CityData] {
        let cityList: [CityData]? = storageManager.object(forKey: .selectedCityList)
        return cityList ?? [currentPlace]
    }

    var currentPlace: CityData {
        CityData(id: .currentPlaceID,
                 name: "Current place",
                 state: "",
                 country: "",
                 coordinate: currentPlaceCoord)
    }

    init() {
        guard let path = Bundle.main.path(forResource: "city_list", ofType: "json"),
              let data = FileManager.default.contents(atPath: path) else {
            fatalError("city_list.json not found")
        }

        let decoder = JSONDecoder()

        cityList = try! decoder.decode([CityData].self, from: data)
    }
}

extension Int {
    static let currentPlaceID = -999_999_999
}
