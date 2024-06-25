//
//  CityDataProvider.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 08.06.2024.
//

import UIKit

protocol CityDataProvider {
    var delegate: CityDataProviderDelegate? { get set}
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

protocol CityDataProviderDelegate: AnyObject {
    func locationFetched()
}

final class CityDataProviderImpl: CityDataProvider {
    static let shared: CityDataProvider = CityDataProviderImpl()

    private let locationProvider = LocationProvider()
    private let udStorageManager = UDStorageManager()
    private let cdStorageManager = CDStorageManager()

    private var currentLocation: Coordinate?

    private var currentPlace: CityData? {
        guard let currentLocation else { return nil }

        return CityData(id: .currentPlaceID,
                        name: "Current place",
                        state: "",
                        country: "",
                        coordinate: currentLocation)
    }

    weak var delegate: CityDataProviderDelegate?

    var selectedCityList: [CityData] {
        get {
            let cityList: [CityData]? = udStorageManager.object(forKey: .selectedCityList)

            if let currentPlace {
                return cityList ?? [currentPlace]
            } else {
                return cityList ?? []
            }
        }
        set {
            udStorageManager.set(object: newValue, fotKey: .selectedCityList)
        }
    }

    private init() {
        locationProvider.delegate = self

        if udStorageManager.object(forKey: .cityListStored) != true {
            guard let path = Bundle.main.path(forResource: "city_list", ofType: "json"),
                  let data = FileManager.default.contents(atPath: path) else {
                fatalError("city_list.json not found")
            }

            let cityList = try! JSONDecoder().decode([CityData].self, from: data)

            cdStorageManager.storeCityData(cityList) { [weak self] result in
                self?.udStorageManager.set(object: result, fotKey: .cityListStored)

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

// MARK: - LocationProviderDelegate
extension CityDataProviderImpl: LocationProviderDelegate {
    func setCurrentLocation(_ location: Coordinate?) {
        currentLocation = location
        
        if location != nil {
            delegate?.locationFetched()
        }
    }

    func showAlert(_ alertController: UIAlertController) {}
}

extension Int {
    static let currentPlaceID = -999_999_999
}
