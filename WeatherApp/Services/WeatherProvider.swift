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

    func sceneDidEnterBackground()
    func sceneWillEnterForeground()

    func getWeatherForCity(with id: Int,
                           completionHandler: @escaping (CityWeatherData) -> Void,
                           errorHandler: ((AppError) -> Void)?)
    func getForecastForCity(with id: Int,
                            completionHandler: @escaping (CityWeatherData) -> Void,
                            errorHandler: ((AppError) -> Void)?)
}

final class WeatherProviderImpl: WeatherProvider {
    weak var delegate: WeatherProviderDelegate?
    private let dataProvider = APIDataProvider()
    private let storageManager = UDStorageManager()

    private var currentPlaceCoord = Coordinate(lat: -20.563568, lon: -50.578311)

    private var weatherCache: [Int: WeatherResponse] = [:]
    private var forecastCache: [Int: ForecastResponse] = [:]
    private var updatedForecastIDs: Set<Int> = []

    private var isNeedUploadNewWeatherData: Bool {
        guard let prevUploadData: Date = storageManager.object(forKey: .weatherUploadDate),
              let nextUploadDate = Calendar.current.date(byAdding: .second, value: 1, to: prevUploadData) else {
            return true
        }

        return nextUploadDate < Date()
    }

    func sceneDidEnterBackground() {

    }

    func sceneWillEnterForeground() {
        if isNeedUploadNewWeatherData {
            updatedForecastIDs = []

            let id = Int.currentPlaceId

            getWeatherForCity(with: id) { [weak self] weatherData in
                guard let self else { return }

                delegate?.setCurrentWeather([weatherData])
                storageManager.set(object: Date(), fotKey: .weatherUploadDate)
            } errorHandler: { error in
                print(#function, error.description)
            }
        }
    }

    func getWeatherForCity(with id: Int,
                           completionHandler:  @escaping (CityWeatherData) -> Void,
                           errorHandler: ((AppError) -> Void)?) {
        let endpount: Endpount = id == .currentPlaceId
            ? .coordWeather(lat: currentPlaceCoord.lat, lon: currentPlaceCoord.lon)
            : .weather(id: id)

        dataProvider.getData(for: endpount) { [weak self] (weather: WeatherResponse) in
            guard let self else { return }

            weatherCache[id] = weather

            let weatherData = prepareCityWeatherData(for: id)
            completionHandler(weatherData)
        } errorHandler: { error in
            errorHandler?(error)
        }
    }

    func getForecastForCity(with id: Int,
                            completionHandler: @escaping (CityWeatherData) -> Void,
                            errorHandler: ((AppError) -> Void)?) {
        if !updatedForecastIDs.contains(id) {
            let endpount: Endpount = id == .currentPlaceId
                ? .coordForecast(lat: currentPlaceCoord.lat, lon: currentPlaceCoord.lon)
                : .forecast(id: id)

            dataProvider.getData(for: endpount) { [weak self] (forecast: ForecastResponse) in
                guard let self else { return }

                forecastCache[id] = forecast
                updatedForecastIDs.insert(id)

                let weatherData = prepareCityWeatherData(for: id)
                completionHandler(weatherData)
            } errorHandler: { error in
                errorHandler?(error)
            }
        }
    }
}

private extension WeatherProviderImpl { 
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

    func prepareCityWeatherData(for id: Int) -> CityWeatherData {
        guard let weatherData = weatherCache[id] else { return .emptyData }

        let title = id == .currentPlaceId ? "Current palce" : weatherData.name
        let subtitle = id == .currentPlaceId
            ? weatherData.name ?? "\(weatherData.coordinate.lat) \(weatherData.coordinate.lon)"
            : nil

        let titleData = TitleViewData(
            title: title,
            subtitle: subtitle,
            currentTemp: weatherData.main.temp,
            description: "Test description", // TODO: Added description with feels like and humidity
            minTemp: weatherData.main.tempMax,
            maxTemp: weatherData.main.tempMin
        )

        return CityWeatherData(id: id,
                               titleData: titleData,
                               dayHourlyDescription: nil, // TODO: Added description
                               dayHourlyData: prepareDayHourlyData(for: forecastCache[id]),
                               dayData: prepareDayData(for: forecastCache[id], and: weatherData))
    }

    func prepareDayHourlyData(for forecast: ForecastResponse?) -> [DayHourlyViewData]? {
        guard let forecast else { return nil }
        var calendar = Calendar.current
        calendar.timeZone = forecast.city.timeZone

        var tempData = forecast.list
            .map { item in // Prepare and forecast data
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH"
                dateFormatter.timeZone = forecast.city.timeZone

                return DayHourlyViewData(date: item.date,
                                         title: dateFormatter.string(from: item.date),
                                         imageSystemName: item.weather.first?.icon.sistemName,
                                         temp: item.main.temp.formatedTemp())
            }

        let nowDate = Date()
        tempData.append(DayHourlyViewData(date: nowDate, // Added today data
                                          title: "Now",
                                          imageSystemName: tempData.first?.imageSystemName,
                                          temp: tempData.first?.temp ?? ""))

        // Prepare and adding sunrise data
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = forecast.city.timeZone

        let sunriseDates = [
            forecast.city.sunriseDate,
            calendar.nextDay(for: forecast.city.sunriseDate)
        ]

        sunriseDates.forEach { date in
            tempData.append(DayHourlyViewData(date: date,
                                              title: dateFormatter.string(from: date),
                                              imageSystemName: "sunrise.fill",
                                              temp: "Sunrise"))
        }

        // Prepare and adding sunset data
        let sunsetDates = [
            forecast.city.sunsetDate,
            calendar.nextDay(for: forecast.city.sunsetDate)
        ]
        sunsetDates.forEach { date in
            tempData.append(DayHourlyViewData(date: date,
                                              title: dateFormatter.string(from: date),
                                              imageSystemName: "sunset.fill",
                                              temp: "Sunset"))
        }

        return tempData
            .sorted { $0.date < $1.date }
            .filter { item in
                item.date >= nowDate
                    && item.date <= calendar.nextDay(for: nowDate)
            }
    }

    func prepareDayData(for forecast: ForecastResponse?, and weatherData: WeatherResponse) -> [DayViewData]? {
        guard let forecast else { return nil }
        var calendar = Calendar.current
        calendar.timeZone = forecast.city.timeZone

        var tempData: [Int: [ForecastResponse.ItemData]] = [:]
        forecast.list.forEach { item in
            let day = calendar.component(.day, from: item.date)

            if var dates = tempData[day] {
                dates.append(item)
                tempData[day] = dates
            } else {
                tempData[day] = [item]
            }
        }

        let minTemp = forecast.list.map { $0.main.tempMin }.min() ?? 0
        let maxTemp = forecast.list.map { $0.main.tempMax }.max() ?? 1

        let dayData = tempData
            .sorted { $0.key < $1.key }
            .map { key, items in
                let minDayTemp = items.map { $0.main.tempMin }.min() ?? 0
                let maxDayTemp = items.map { $0.main.tempMax }.max() ?? 1

                let todayKey = calendar.component(.day, from: Date())
                if key == todayKey {
                    return DayViewData(title: "Today",
                                       imageSystemName: weatherData.weather.first?.icon.sistemName,
                                       minTemp: minTemp,
                                       maxTemp: maxTemp,
                                       minDayTemp: minTemp, // Data not available
                                       maxDayTemp: maxTemp, // Data not available
                                       currentTemt: weatherData.main.temp)

                } else {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "EEE"
                    dateFormatter.timeZone = forecast.city.timeZone

                    return DayViewData(title: dateFormatter.string(from: items.first?.date ?? Date()),
                                       imageSystemName: items.first?.weather.first?.icon.sistemName,
                                       minTemp: minTemp,
                                       maxTemp: maxTemp,
                                       minDayTemp: minDayTemp,
                                       maxDayTemp: maxDayTemp,
                                       currentTemt: nil)
                }
            }
        return dayData
    }
}

fileprivate extension Calendar {
    func nextDay(for date: Date) -> Date {
        self.date(byAdding: .day, value: 1, to: date) ?? date
    }
}
