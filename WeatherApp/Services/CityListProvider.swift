//
//  CityListProvider.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 08.06.2024.
//

import Foundation

protocol CityListProvider {
    var cityList: [CityData] { get }
    var selectedCityList: [CityData] { get set }

    func add(_ city: CityData)
    func delete(_ city: CityData)
}

final class CityListProviderImpl: CityListProvider {
    private let storageManager = UDStorageManager()
    private var currentPlaceCoord = Coordinate(lat: -20.563568, lon: -50.578311)

    var cityList: [CityData] = []
    var selectedCityList: [CityData] {
        get {
            let cityList: [CityData]? = storageManager.object(forKey: .selectedCityList)
            return cityList ?? [currentPlace]
        }
        set {
            storageManager.set(object: newValue, fotKey: .selectedCityList)
        }
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

    func add(_ city: CityData) {
        var selectedCityList: [CityData] = selectedCityList
        selectedCityList.append(city)
        storageManager.set(object: selectedCityList, fotKey: .selectedCityList)
    }

    func delete(_ city: CityData) {
        guard city.id != .currentPlaceID,
            let index = selectedCityList.firstIndex(where: { $0.id == city.id }) else { return }

        selectedCityList.remove(at: index)
    }
}

extension Int {
    static let currentPlaceID = -999_999_999
}
