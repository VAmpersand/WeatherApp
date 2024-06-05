//
//  WeatherProvider.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 05.06.2024.
//

import UIKit


protocol WeatherProviderDelegate: AnyObject {
    func setCurrentWeather(_ data: [CityWeatherData])
}

protocol WeatherProvider {
    var delegate: WeatherProviderDelegate? { get set }
    var weatherDataCache: [CityWeatherData] { get set }

    func sceneDidEnterBackground()
    func sceneWillEnterForeground()
}

final class WeatherProviderImpl: WeatherProvider {
    weak var delegate: WeatherProviderDelegate?

    var weatherDataCache: [CityWeatherData] = []

    func sceneDidEnterBackground() {

    }

    func sceneWillEnterForeground() {
        delegate?.setCurrentWeather(CityWeatherData.mockData)

        weatherDataCache = CityWeatherData.mockData
    }
}
