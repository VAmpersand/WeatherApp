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
    var dataSource: [CityWeatherViewModel.Section] { get set }

    func setupTitle(with data: TitleData)
}

extension CityWeatherViewModel {
    struct Section {
        let icon: UIImage?
        let title: String?
        let items: [Item]
    }

    enum Item {
        case title(data: TitleCell.InputModel)
        case dayHourlyWeather(data: [DayHourlyData])
        case dayWeather(data: DayData)
    }
}

final class CityWeatherViewModel: CityWeatherViewModelInput {
    private let weatherData: MOCKData?

    weak var output: CityWeatherViewModelOutput?

    init(with weatherData: MOCKData?) {
        self.weatherData = weatherData
    }

    func viewDidLoad() {
        if let weatherData {
            output?.setupTitle(with: weatherData.titleData)

            prepareDataSource(from: weatherData)
        }
    }

    private func prepareDataSource(from weatherData: MOCKData) {
//        var forecastItems: [Item] = weatherData.dayData.map { .dayWeather(data: $0) }
//        forecastItems.insert(
//            .title(data: TitleCell.InputModel(imageSystemName: "calendar",
//                                              title: "Forecast for \(weatherData.dayData.count) days")),
//            at: 0
//        )
//
//        output?.dataSource = [
//            Section(icon: nil,
//                    title: nil,
//                    items: [
//                        .title(data: TitleCell.InputModel(imageSystemName: "clock",
//                                                          title: "Hourly forecast")),
//                        .dayHourlyWeather(data: weatherData.dayHourlyData.data)
//                    ]),
//            Section(icon: nil,
//                    title: nil,
//                    items: forecastItems)
//        ]
    }
}
