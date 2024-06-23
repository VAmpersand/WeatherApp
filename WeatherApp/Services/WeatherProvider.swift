//
//  WeatherProvider.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 05.06.2024.
//

import UIKit

protocol WeatherProviderDelegate: AnyObject {
    func setCurrentWeather(_ data: [Int: CityWeatherData])
}

protocol WeatherProvider {
    var delegate: WeatherProviderDelegate? { get set }

    func getWeather(for city: CityData,
                    completionHandler: @escaping ([Int: CityWeatherData]) -> Void,
                    errorHandler: ((AppError) -> Void)?)
    func getWeather(for cityList: [CityData],
                    forced: Bool,
                    completionHandler: @escaping ([Int: CityWeatherData]) -> Void,
                    errorHandler: ((AppError) -> Void)?)
    func getForecast(for cityData: CityData,
                     completionHandler: @escaping ([Int: CityWeatherData]) -> Void,
                     errorHandler: ((AppError) -> Void)?)
}

final class WeatherProviderImpl: WeatherProvider {
    weak var delegate: WeatherProviderDelegate?
    private let dataProvider = APIDataProvider()
    private let storageManager = UDStorageManager()
    private let cityDataProwider = CityDataProviderImpl.shared

    private var weatherDataCache: [Int: CityWeatherData] = [:]
    private var weatherCache: [Int: WeatherResponse] = [:]
    private var forecastCache: [Int: ForecastResponse] = [:]
    private var updatedForecastIDs: Set<Int> = []
    private var weatherIsLoading = false
    private var forecastIsLoading: [Int: Bool] = [:]


    private var isNeedUploadNewWeatherData: Bool {
        guard let prevUploadData: Date = storageManager.object(forKey: .weatherUploadDate),
              let nextUploadDate = Calendar.current.date(byAdding: .hour, value: 1, to: prevUploadData) else {
            return true
        }
        return weatherDataCache.isEmpty || nextUploadDate < Date()
    }

    func getWeather(for cityList: [CityData],
                    forced: Bool,
                    completionHandler: @escaping ([Int: CityWeatherData]) -> Void,
                    errorHandler: ((AppError) -> Void)?) {
        if (isNeedUploadNewWeatherData || forced) && !weatherIsLoading {
            weatherIsLoading = true

            updatedForecastIDs = []
            var cityListWeatherFetched = cityList.count == 1
            var cityListWeather: [Int: CityWeatherData] = [:]

            if let currentPlace = cityList.first(where: { $0.id == .currentPlaceID }) {
                getWeather(
                    for: currentPlace,
                    completionHandler: { data in
                        cityListWeather[.currentPlaceID] = data[.currentPlaceID]

                        if cityListWeatherFetched {
                            succeedCompletion(cityListWeather)
                        }
                    },
                    errorHandler: { [weak self] error in
                        errorHandler?(error)

                        self?.weatherIsLoading = false
                    }
                )
            }

            let filteredCityList = cityList.filter { $0.id != .currentPlaceID }

            if !filteredCityList.isEmpty {
                getWeather(
                    for: filteredCityList,
                    completionHandler: { data in
                        data.forEach { key, value in
                            cityListWeather[key] = value
                        }
                        cityListWeatherFetched = true

                        if cityListWeather[.currentPlaceID] != nil {
                            succeedCompletion(cityListWeather)
                        }
                    },
                    errorHandler: { [weak self] error in
                        errorHandler?(error)

                        self?.weatherIsLoading = false
                    }
                )
            }
        } else {
            completionHandler(weatherDataCache)
        }

        func succeedCompletion(_ cityListWeather: [Int: CityWeatherData]) {
            completionHandler(cityListWeather)
            storageManager.set(object: Date(), fotKey: .weatherUploadDate)
            weatherIsLoading = false
        }
    }

    func getWeather(for cityData: CityData,
                    completionHandler: @escaping ([Int: CityWeatherData]) -> Void,
                    errorHandler: ((AppError) -> Void)?) {
        let endpount: Endpount = cityData.id == .currentPlaceID
            ? .coordWeather(cityData.coordinate)
            : .weather(id: cityData.id)

        dataProvider.getData(for: endpount) { [weak self] (weather: WeatherResponse) in
            guard let self else { return }

            weatherCache[cityData.id] = weather

            let weatherData = prepareCityWeatherData(for: cityData.id)
            weatherDataCache[cityData.id] = weatherData

            completionHandler(weatherDataCache)
        } errorHandler: { error in
            errorHandler?(error)
        }
    }

    func getForecast(for cityData: CityData,
                     completionHandler: @escaping ([Int: CityWeatherData]) -> Void,
                     errorHandler: ((AppError) -> Void)?) {
        if !updatedForecastIDs.contains(cityData.id) && (forecastIsLoading[cityData.id] ?? false) != true {
            forecastIsLoading[cityData.id] = true

            let endpount: Endpount = cityData.id == .currentPlaceID
                ? .coordForecast(cityData.coordinate)
                : .forecast(id: cityData.id)

            dataProvider.getData(for: endpount) { [weak self] (forecast: ForecastResponse) in
                guard let self else { return }

                forecastCache[cityData.id] = forecast
                updatedForecastIDs.insert(cityData.id)

                let weatherData = prepareCityWeatherData(for: cityData.id)
                weatherDataCache[cityData.id] = weatherData

                completionHandler(weatherDataCache)
                forecastIsLoading[cityData.id] = nil
            } errorHandler: { error in
                errorHandler?(error)
            }
        }
    }
}

private extension WeatherProviderImpl {
    func getWeather(for cityGroup: [CityData],
                    completionHandler: @escaping ([Int: CityWeatherData]) -> Void,
                    errorHandler: ((AppError) -> Void)?) {
        dataProvider.getData(for: .group(ids: cityGroup.map(\.id))) { [weak self] (group: GroupResponse) in
            guard let self else { return }

            group.list.forEach { weather in
                guard let id = weather.id else { return }

                self.weatherCache[id] = weather

                let weatherData = self.prepareCityWeatherData(for: id)
                self.weatherDataCache[id] = weatherData
            }

            completionHandler(weatherDataCache)
        } errorHandler: { error in
            print(#function, error.description)
        }
    }

    func prepareCityWeatherData(for id: Int) -> CityWeatherData {
        guard let weatherData = weatherCache[id] else { return .emptyData }

        let title = id == .currentPlaceID ? "Current palce" : weatherData.name
        let subtitle = id == .currentPlaceID
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
