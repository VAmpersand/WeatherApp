//
//  CityWeatherViewModel.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 29.05.2024.
//

import UIKit

protocol CityWeatherViewModelInput {
    var output: CityWeatherViewModelOutput? { get set }

    func viewDidLoad()
}

protocol CityWeatherViewModelOutput: AnyObject {
    var sections: [CityWeatherViewModel.Section] { get set }

    func setupTitle(with data: TitleData)
}

extension CityWeatherViewModel {
    struct Section: Hashable {
        let imageSystemName: String
        let title: String
        let description: String?
        let items: [Item]
    }

    enum Item: Hashable {
        case dayHourlyWeather(data: DayHourlyData)
        case dayWeather(data: DayData)

        var id: String {
            switch self {
            case .dayHourlyWeather(let data): return data.id
            case .dayWeather(let data): return data.id
            }
        }
    }
}

final class CityWeatherViewModel: CityWeatherViewModelInput {
    private let weatherData: CityWeatherData!

    weak var output: CityWeatherViewModelOutput?

    init(with weatherData: CityWeatherData?) {
        self.weatherData = weatherData ?? CityWeatherData.mockData.first
    }

    func viewDidLoad() {
        output?.setupTitle(with: weatherData.titleData)

        prepareDataSource()
    }

    private func prepareDataSource() {
        output?.sections = [
            Section(imageSystemName: "clock",
                    title: "Hourly forecast",
                    description: weatherData.dayHourlyDescription,
                    items: weatherData.dayHourlyData.map { .dayHourlyWeather(data: $0) }),
            Section(imageSystemName: "calendar",
                    title: "Forecast for \(weatherData.dayData.count) days",
                    description: nil,
                    items: weatherData.dayData.map { .dayWeather(data: $0) })
        ]
    }
}
