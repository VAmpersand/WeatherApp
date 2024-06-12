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
    
    func getForecastForCity(with id: Int,
                            completionHandler: @escaping (CityWeatherData) -> Void,
                            errorHandler: ((AppError) -> Void)?)
}

final class WeatherProviderImpl: WeatherProvider {
    weak var delegate: WeatherProviderDelegate?
    private let dataProvider = APIDataProvider()

    private var currentPlaceCoord = Coordinate(lat: -48.563568, lon: -130.578311)

    private var weatherDataCache: [Int: CityWeatherData] = [:]
    private var weatherCache: [Int: WeatherResponse] = [:]
    private var forecastCache: [Int: ForecastResponse] = [:]
    
    func sceneDidEnterBackground() {
        
    }
    
    func sceneWillEnterForeground() {
        let id = Int.currentPlaceId
        
        getWeatherForCity(with: id) { [weak self] weather in
            guard let self else { return }
            
            weatherCache[id] = weather
            
            let weatherData = prepareCityWeatherData(for: id, and: weather)
            weatherDataCache[id] = weatherData
            delegate?.setCurrentWeather([weatherData])
        } errorHandler: { error in
            print(#function, error.description)
        }
    }
    
    func getForecastForCity(with id: Int,
                            completionHandler: @escaping (CityWeatherData) -> Void,
                            errorHandler: ((AppError) -> Void)?) {
        if let forecast = forecastCache[id] {
            let weatherData = prepareCityWeatherData(for: id, and: forecast)
            weatherDataCache[id] = weatherData
            completionHandler(weatherData)

        } else {
            let endpount: Endpount = id == .currentPlaceId
                ? .coordForecast(lat: currentPlaceCoord.lat, lon: currentPlaceCoord.lon)
                : .forecast(id: id)
            
            dataProvider.getData(for: endpount) { [weak self] (forecast: ForecastResponse) in
                guard let self else { return }
                
                forecastCache[id] = forecast
                let weatherData = prepareCityWeatherData(for: id, and: forecast)
                weatherDataCache[id] = weatherData
                completionHandler(weatherData)

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
    
    func prepareCityWeatherData(for id: Int, and weather: WeatherResponse) -> CityWeatherData {
        let title = id == .currentPlaceId ? "Current palce" : weather.name
        let subtitle = id == .currentPlaceId
        ? weather.name ?? "\(weather.coordinate.lat) \(weather.coordinate.lon)"
        : nil
        
        let weatherData = CityWeatherData(
            id: id,
            titleData: TitleViewData(
                title: title,
                subtitle: subtitle,
                currentTemp: weather.main.temp.formatedTemp(),
                description: weather.weather.first?.main ?? "",
                minTemp: weather.main.tempMax.formatedTemp(),
                maxTemp: weather.main.tempMin.formatedTemp()
            ),
            forecastData: weatherDataCache[id]?.forecastData
        )
        
        return weatherData
    }
    
    func prepareCityWeatherData(for id: Int, and forecast: ForecastResponse) -> CityWeatherData {
        let titleData: TitleViewData
        if let prewWeatherData = weatherDataCache[id] {
            titleData = prewWeatherData.titleData
        } else {
            let firstItem = forecast.list.first
            titleData = TitleViewData(title: forecast.city.name,
                                      subtitle: nil,
                                      currentTemp: firstItem?.main.temp.formatedTemp() ?? "--",
                                      description: firstItem?.main.feelsLike.formatedTemp() ?? "--",
                                      minTemp: firstItem?.main.tempMin.formatedTemp() ?? "--",
                                      maxTemp: firstItem?.main.tempMax.formatedTemp() ?? "--")
        }

        let weatherData = CityWeatherData(
            id: id,
            titleData: titleData,
            forecastData: CityForecastData(
                dayHourlyDescription: "Cloudy weather from 9:00 to 19:00, mostly sunny weather is expected at 12:00",
                dayHourlyData: prepareDayHourlyData(),
                dayData: [
                    DayViewData(title: "Today",
                                imageSystemName: "sun.max.fill",
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                    DayViewData(title: "SU",
                                imageSystemName: "sun.max.fill",
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                    DayViewData(title: "MO",
                                imageSystemName: "sun.max.fill",
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                    DayViewData(title: "TU",
                                imageSystemName: "sun.max.fill",
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                    DayViewData(title: "WE",
                                imageSystemName: "sun.max.fill",
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                    DayViewData(title: "TH",
                                imageSystemName: "sun.max.fill",
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                    DayViewData(title: "FR",
                                imageSystemName: "sun.max.fill",
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                    DayViewData(title: "SA",
                                imageSystemName: "sun.max.fill",
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                ]
            )
        )

        return weatherData

        func prepareDayHourlyData() -> [DayHourlyViewData] {
            let calendar = Calendar.current

            var tempData = forecast.list
                .filter { item in // Filter forecast data only for on day
                    if let nexDay = calendar.date(byAdding: .day, value: 1, to: Date()),
                       item.date > nexDay {
                        return false
                    }

                    return true
                }
                .map { item in // Prepare and simplified data

                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH"
                    dateFormatter.timeZone = forecast.city.timeZone

                    return (date: item.date,
                            dateStr: dateFormatter.string(from: item.date),
                            imageSystemName: item.weather.first?.icon.sistemName,
                            temp: item.main.temp.formatedTemp())
                }

            tempData.append((date: Date(), // Added today data
                             dateStr: "Now",
                             imageSystemName: tempData.first?.imageSystemName,
                             temp: tempData.first?.temp ?? ""))

            // Prepare and add sunrise/sunset data
            let sunriseDate: Date
            let sunsetDate: Date
            if forecast.list.first?.system.partOfDay == .day {
                sunriseDate = calendar.date(byAdding: .day, value: 1, to: forecast.city.sunriseDate)  ?? Date()
                sunsetDate = forecast.city.sunsetDate
            } else {
                sunriseDate = forecast.city.sunriseDate
                sunsetDate = calendar.date(byAdding: .day, value: 1, to: forecast.city.sunsetDate) ?? Date()
            }

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.timeZone = forecast.city.timeZone
            tempData.append((date: sunriseDate,
                             dateStr: dateFormatter.string(from: sunriseDate),
                             imageSystemName: "sunrise.fill",
                             temp: "Sunrise"))
            tempData.append((date: sunsetDate,
                             dateStr: dateFormatter.string(from: sunsetDate),
                             imageSystemName: "sunset.fill",
                             temp: "Sunset"))

            return tempData
                .sorted { $0.date < $1.date } // Sorting by date for correct displaying order 
                .map { item in
                    return DayHourlyViewData(title: item.dateStr,
                                             imageSystemName: item.imageSystemName ?? "sun.fill",
                                             temp: item.temp)
                }
        }
    }
}
