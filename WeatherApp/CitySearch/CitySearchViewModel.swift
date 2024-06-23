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
    private let cityDataProvider: CityDataProvider = CityDataProviderImpl.shared

    func filterCity(with searchQuery: String) {
        output?.searchQuery = searchQuery

        if searchQuery.isEmpty {
            output?.cityList = []
        } else {
            cityDataProvider.getCityList(with: searchQuery) { [weak self] cityList in
                self?.output?.cityList = cityList ?? []
            }
        }
    }

    func select(_ city: CityData) {
        cityDataProvider.add(city)
    }
}
