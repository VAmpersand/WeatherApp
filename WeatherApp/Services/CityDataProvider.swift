//
//  CityDataProvider.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 08.06.2024.
//

import Foundation

protocol CityDataProvider {
    var selectedCityList: [CityData] { get set }

    func add(_ city: CityData)
    func delete(_ city: CityData)
    func getCityList(with searchQuery: String?, completion: @escaping ([CityData]?) -> Void)
}

extension CityDataProvider {
    func getCityList(with searchQuery: String? = nil, completion: @escaping ([CityData]?) -> Void) {
        getCityList(with: searchQuery, completion: completion)
    }
}

final class CityListProviderImpl: CityDataProvider {
    private let udStorageManager = UDStorageManager()
    private let cdStorageManager = CDStorageManager()

    private var currentPlaceCoord = Coordinate(lat: -20.563568, lon: -50.578311)

    var selectedCityList: [CityData] {
        get {
            let cityList: [CityData]? = udStorageManager.object(forKey: .selectedCityList)
            return cityList ?? [currentPlace]
        }
        set {
            udStorageManager.set(object: newValue, fotKey: .selectedCityList)
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
        if udStorageManager.object(forKey: .cityListStored) != true {
            guard let path = Bundle.main.path(forResource: "city_list", ofType: "json"),
                  let data = FileManager.default.contents(atPath: path) else {
                fatalError("city_list.json not found")
            }

            let cityList = try! JSONDecoder().decode([CityData].self, from: data)

            cdStorageManager.storeCityData(cityList) { result in
                print("Storing cityList - \(result ? "sucess" : "failed")")
            }
        }
    }

    func add(_ city: CityData) {
        var selectedCityList: [CityData] = selectedCityList
        selectedCityList.append(city)
        udStorageManager.set(object: selectedCityList, fotKey: .selectedCityList)
    }

    func delete(_ city: CityData) {
        guard city.id != .currentPlaceID,
            let index = selectedCityList.firstIndex(where: { $0.id == city.id }) else { return }

        selectedCityList.remove(at: index)
    }

    func getCityList(with searchQuery: String?, completion: @escaping ([CityData]?) -> Void) {
        if let searchQuery {
            cdStorageManager.fetchCityData(with: searchQuery, completion: completion)
        } else {
            cdStorageManager.fetchCityData(completion: completion)
        }
    }
}

extension Int {
    static let currentPlaceID = -999_999_999
}
