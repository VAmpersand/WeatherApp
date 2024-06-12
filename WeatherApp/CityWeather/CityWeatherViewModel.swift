//
//  CityWeatherViewModel.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 29.05.2024.
//

import UIKit

protocol CityWeatherViewModelInput {
    var output: CityWeatherViewModelOutput? { get set }

    func setup(_ weatherData: CityWeatherData)
    func viewDidLoad()
}

protocol CityWeatherViewModelOutput: AnyObject {
    var sections: [CityWeatherViewModel.Section] { get set }

    func setupTitle(with data: TitleViewData)
}

extension CityWeatherViewModel {
    struct Section: Hashable {
        let imageSystemName: String
        let title: String
        let description: String?
        let items: [Item]
    }

    enum Item: Hashable {
        case dayHourlyWeather(data: DayHourlyViewData)
        case dayWeather(data: DayViewData)

        var id: String {
            switch self {
            case .dayHourlyWeather(let data): return "\(data.date)"
            case .dayWeather(let data): return data.id
            }
        }
    }
}

final class CityWeatherViewModel: CityWeatherViewModelInput {
    private var weatherData: CityWeatherData = .emptyData

    weak var output: CityWeatherViewModelOutput?

    func setup(_ weatherData: CityWeatherData) {
        self.weatherData = weatherData

        viewDidLoad()
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
                    items: weatherData.dayHourlyData?.map { .dayHourlyWeather(data: $0) } ?? []),
            Section(imageSystemName: "calendar",
                    title: "Forecast for \(weatherData.dayData?.count ?? 0) days",
                    description: nil,
                    items: weatherData.dayData?.map { .dayWeather(data: $0) } ?? [])
        ]
    }
}
