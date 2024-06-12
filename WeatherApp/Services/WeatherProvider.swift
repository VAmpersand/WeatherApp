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
    private let dataProvider = APIDataProvider()

    var weatherDataCache: [CityWeatherData] = []

    func sceneDidEnterBackground() {

    }

    func sceneWillEnterForeground() {
//        delegate?.setCurrentWeather(CityWeatherData.mockData)
//
//        weatherDataCache = CityWeatherData.mockData

        let coord = Coordinate(lat: -34.603722, lon: -58.381592)
        getWeather(for: coord)
        getForecast(for: coord)
    }

    private func getCityWeather(for id: Int) {
        dataProvider.getData(for: .weather(id: id)) { (weather: WeatherResponse) in
            print("Weather", weather)
        } errorHandler: { error in
            print(#function, error.description)
        }
    }

    private func getCityForecast(for id: Int) {
        dataProvider.getData(for: .forecast(id: id)) { (forecast: ForecastResponse) in
            print("Forecast", forecast)
        } errorHandler: { error in
            print(#function, error.description)
        }
    }

    private func getWeather(for coord: Coordinate) {
        dataProvider.getData(for: .coordWeather(lat: coord.lat, lon: coord.lon)) { (weather: WeatherResponse) in
            print("Weather", weather)
        } errorHandler: { error in
            print(#function, error.description)
        }
    }

    private func getForecast(for coord: Coordinate) {
        dataProvider.getData(for: .coordForecast(lat: coord.lat, lon: coord.lon)) { (forecast: ForecastResponse) in
            print("Forecast", forecast)
        } errorHandler: { error in
            print(#function, error.description)
        }
    }

    private func getGroupWeather(for ids: [Int]) {
        dataProvider.getData(for: .group(ids: ids)) { (weathers: [WeatherResponse]) in
            print("Group", weathers)
        } errorHandler: { error in
            print(#function, error.description)
        }
    }
}
