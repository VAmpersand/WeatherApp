//
//  WeatherProvider.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 05.06.2024.
//

import UIKit

extension Int {
    static let currentPlaceId = -999_999_999
}

protocol WeatherProviderDelegate: AnyObject {
    func setCurrentWeather(_ data: [CityWeatherData])
}

protocol WeatherProvider {
    var delegate: WeatherProviderDelegate? { get set }
    var weatherDataCache: [CityWeatherData] { get set }

    func sceneDidEnterBackground()
    func sceneWillEnterForeground()

    func getForecastForCity(with id: Int,
                            completionHandler: @escaping (ForecastResponse) -> Void,
                            errorHandler: ((AppError) -> Void)?)
}

final class WeatherProviderImpl: WeatherProvider {
    weak var delegate: WeatherProviderDelegate?
    private let dataProvider = APIDataProvider()

    private var currentPlaceCoord = Coordinate(lat: -34.603722, lon: -58.381592)

    var weatherDataCache: [CityWeatherData] = []

    private var weatherCache: [Int: WeatherResponse] = [:]
    private var forecastCache: [Int: ForecastResponse] = [:]

    func sceneDidEnterBackground() {

    }

    func sceneWillEnterForeground() {
        getWeatherForCity(with: .currentPlaceId) { [weak self] weather in
            let weatherData = CityWeatherData(
                id: .currentPlaceId,
                titleData: TitleViewData(
                    title: "Current palce",
                    subtitle: weather.name ?? "\(weather.coordinate.lat) \(weather.coordinate.lon)",
                    currentTemp: weather.main.temp.formatedTemp(),
                    description: weather.weather.first?.main ?? "",
                    minTemp: weather.main.tempMax.formatedTemp(),
                    maxTemp: weather.main.tempMin.formatedTemp()
                ),
                dayHourlyDescription: weather.weather.first?.description ?? "",
                dayHourlyData: [],
                dayData: []
            )
            self?.delegate?.setCurrentWeather([weatherData])
        } errorHandler: { error in
            print(#function, error.description)
        }
    }

    func getForecastForCity(with id: Int,
                            completionHandler: @escaping (ForecastResponse) -> Void,
                            errorHandler: ((AppError) -> Void)?) {
        if let forecast = forecastCache[id] {
            completionHandler(forecast)

        } else {
            let endpount: Endpount = id == .currentPlaceId
                ? .coordForecast(lat: currentPlaceCoord.lat, lon: currentPlaceCoord.lon)
                : .forecast(id: id)

            dataProvider.getData(for: endpount) { [weak self] (forecast: ForecastResponse) in
                guard let self else { return }

                forecastCache[id] = forecast
                completionHandler(forecast)
            } errorHandler: { error in
                errorHandler?(error)
            }
        }
    }
}

private extension WeatherProviderImpl {
    func getWeatherForCity(with id: Int,
                           completionHandler:  @escaping (WeatherResponse) -> Void,
                           errorHandler: ((AppError) -> Void)?) {
        let endpount: Endpount = id == .currentPlaceId
            ? .coordWeather(lat: currentPlaceCoord.lat, lon: currentPlaceCoord.lon)
            : .weather(id: id)

        dataProvider.getData(for: endpount) { [weak self] (weather: WeatherResponse) in
            guard let self, let id = weather.id  else { return }

            weatherCache[id] = weather
            completionHandler(weather)
        } errorHandler: { error in
            errorHandler?(error)
        }
    }

    func getGroupWeather(for ids: [Int], completionHandler: (ForecastResponse) -> Void, errorHandler: ((AppError) -> Void)?) {
        dataProvider.getData(for: .group(ids: ids)) { [weak self] (weathers: [WeatherResponse]) in
            guard let self else { return }

            weathers.forEach { weather in
                if let id = weather.id {
                    self.weatherCache[id] = weather
                }
            }
        } errorHandler: { error in
            print(#function, error.description)
        }
    }
}
