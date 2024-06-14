//
//  CitySelectionViewModel.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 01.06.2024.
//

import UIKit

protocol CitySelectionViewModelInput {
    var output: CitySelectionViewModelOutput? { get set }

    func getForecastForCity(with id: Int?)
}

protocol CitySelectionViewModelOutput: AnyObject {
    var sections: [CitySelectionViewModel.Section] { get set }

    func setup(_ weatherData: CityWeatherData)
}

extension CitySelectionViewModel {
    struct Section: Hashable {
        let items: [CityWeatherData]
        let footerAttributedString: NSAttributedString?
    }
}

final class CitySelectionViewModel: CitySelectionViewModelInput {
    weak var output: CitySelectionViewModelOutput?
    private var weatherProvider: WeatherProvider?

    init(weatherProvider: WeatherProvider) {
        self.weatherProvider = weatherProvider
        self.weatherProvider?.delegate = self
    }

    func getForecastForCity(with id: Int?) {
        guard let id else { return }

        weatherProvider?.getForecastForCity(with: id) { [weak self] weatherData in
            self?.output?.setup(weatherData)
            self?.prepareSections(with: [weatherData])
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
    func setCurrentWeather(_ data: [CityWeatherData]) {
        prepareSections(with: data)
    }
}
