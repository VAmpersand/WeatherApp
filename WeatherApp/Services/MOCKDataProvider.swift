//
//  MOCKDataProvider.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 18.05.2024.
//

import UIKit

struct CityWeatherData: Hashable {
    let id: Int
    let titleData: TitleViewData
    let dayHourlyDescription: String?
    let dayHourlyData: [DayHourlyViewData]?
    let dayData: [DayViewData]?
}

struct TitleViewData: Hashable {
    let title: String?
    let subtitle: String?
    let currentTemp: Double?
    let description: String?
    let minTemp: Double?
    let maxTemp: Double?
}

struct DayHourlyViewData: Hashable {
    let date: Date
    let title: String
    let imageSystemName: String?
    let temp: String
}

struct DayViewData: Hashable {
    let title: String
    let imageSystemName: String?
    let minTemp: Double
    let maxTemp: Double
    let minDayTemp: Double
    let maxDayTemp: Double
    let currentTemt: Double?

    var id: String {
        "\(title) \(imageSystemName) \(minTemp) \(maxTemp) \(minDayTemp) \(maxDayTemp) \(String(describing: currentTemt))"
    }
}

extension CityWeatherData {
    static var emptyData: CityWeatherData {
        CityWeatherData(
            id: .currentPlaceId,
            titleData: TitleViewData(title: "--",
                                     subtitle: "--",
                                     currentTemp: nil,
                                     description: "--",
                                     minTemp: nil,
                                     maxTemp: nil),
            dayHourlyDescription: nil,
            dayHourlyData: nil,
            dayData: nil
        )
    }
}

