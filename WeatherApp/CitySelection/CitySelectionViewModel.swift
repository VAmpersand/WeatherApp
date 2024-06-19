//
//  CitySelectionViewModel.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 01.06.2024.
//

import UIKit

protocol CitySelectionViewModelInput {
    var output: CitySelectionViewModelOutput? { get set }

    func getWeatherForCityList()
    func getForecastForCity(with id: Int?)
}

protocol CitySelectionViewModelOutput: AnyObject {
    var sections: [CitySelectionViewModel.Section] { get set }
}

extension CitySelectionViewModel {
    struct Section: Hashable {
        let items: [CityWeatherData]
        let footerAttributedString: NSAttributedString?
    }
}

final class CitySelectionViewModel: CitySelectionViewModelInput {
    weak var output: CitySelectionViewModelOutput?
    private let storageManager = UDStorageManager()
    private let cityListProvider: CityDataProvider = CityListProviderImpl()
    private var weatherProvider: WeatherProvider?

    var cityList: [CityData] {
        cityListProvider.selectedCityList
    }

    init(weatherProvider: WeatherProvider) {
        self.weatherProvider = weatherProvider
        self.weatherProvider?.delegate = self

        prepareSections(with: cityList.map(\.weatherData))
        getWeatherForCityList()
    }

    func getWeatherForCityList() {
        weatherProvider?.getWeatherFor(cityList) { [weak self] data in
            guard let self else { return }

            let sortedData = cityList.compactMap { data[$0.id] ?? $0.weatherData }
            prepareSections(with: sortedData)
        } errorHandler: { error in
            print(#function, error.description)
        }
    }

    func getForecastForCity(with id: Int?) {
        guard let id, let cityData = cityList.first(where: { $0.id == id }) else { return }

        weatherProvider?.getForecastForCity(cityData) { [weak self] data in
            guard let self else { return }
            let sortedData = cityList.compactMap { data[$0.id] ?? $0.weatherData }
            prepareSections(with: sortedData)
        } errorHandler: { error in
            print(#function, error.description)
        }
    }

    private func prepareSections(with data: [CityWeatherData]) {
        output?.sections = [Section(items: data, footerAttributedString: createFooterString())]
    }

    private func createFooterString() -> NSAttributedString {
        let text = "Learn more about meteorological data"
        let attributedString = NSMutableAttributedString(
            string: text,
            attributes: [.foregroundColor: UIColor.gray])

        if let url = URL(string: "https://meteoinfo.ru/t-scale") {
            let linkRange = (text as NSString).range(of: "meteorological data")

            attributedString.addAttributes([.link: url], range: linkRange)
        }

        return attributedString
    }
}

// MARK: - WeatherProviderDelegate
extension CitySelectionViewModel: WeatherProviderDelegate {
    func setCurrentWeather(_ data: [Int: CityWeatherData]) {
        let sortedData = cityList.compactMap { data[$0.id] ?? $0.weatherData }
        prepareSections(with: sortedData)
    }
}
