//
//  CitySearchViewModel.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 08.06.2024.
//

import Foundation

protocol CitySearchViewModelInput {
    var output: CitySearchViewModelOutput? { get set }

    func filterCity(with searchQuery: String)
    func select(_ city: CityData)
}

protocol CitySearchViewModelOutput: AnyObject {
    var searchQuery: String { get set }
    var cityList: [CityData] { get set }
}

final class CitySearchViewModel: CitySearchViewModelInput {
    weak var output: CitySearchViewModelOutput?

    private let storageManager = UDStorageManager()
    private let cityListProvider: CityDataProvider

    init(cityListProvider: CityDataProvider) {
        self.cityListProvider = cityListProvider

//        cityListProvider.getCityList { [weak self] cityList in
//            self?.output?.cityList = cityList ?? []
//        }
    }

    func filterCity(with searchQuery: String) {
        output?.searchQuery = searchQuery

        if searchQuery.isEmpty {
            output?.cityList = []
        } else {
            cityListProvider.getCityList(with: searchQuery) { [weak self] cityList in
                self?.output?.cityList = cityList ?? []
            }

//            output?.cityList = cityListProvider.cityList.filter {
//                $0.name.lowercased().contains(searchQuery)
//                || $0.country.lowercased().contains(searchQuery)
//                || $0.state.lowercased().contains(searchQuery)
//            }
        }
    }

    func select(_ city: CityData) {
        cityListProvider.add(city)
    }
}
