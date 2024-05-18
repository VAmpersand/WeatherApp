//
//  MOCKDataProvider.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 18.05.2024.
//

import UIKit

typealias TitleData = TitleView.InputModel
typealias DayHourlyData = DayHourlyWeatherView.InputModel
typealias DayData = DayWeatherView.InputModel

struct MOCKData {
    let titleData: TitleData
    let dayHourlyData: (description: String, data: [DayHourlyData])
    let dayData: [DayData]
}

extension MOCKData {
    static var data: [MOCKData] {
        return [
            // MARK: - MOCK Data for first city
            MOCKData(titleData: TitleData(title: "Current palce",
                                          subtitle: "BUENOS AIRES",
                                          currentTemp: 19,
                                          description: "Clear sky",
                                          minTemp: 15,
                                          maxTemp: 22),
                     dayHourlyData: (description: "Cloudy weather from 9:00 to 19:00, mostly sunny weather is expected at 12:00",
                                     data: [
                                        DayHourlyData(hour: "Now",
                                                      icon: UIImage(systemName: "sun.max.fill"),
                                                      temp: 15),
                                        DayHourlyData(hour: "09",
                                                      icon: UIImage(systemName: "sun.max.fill"),
                                                      temp: 15),
                                        DayHourlyData(hour: "10",
                                                      icon: UIImage(systemName: "sun.max.fill"),
                                                      temp: 15),
                                        DayHourlyData(hour: "11",
                                                      icon: UIImage(systemName: "sun.max.fill"),
                                                      temp: 15),
                                        DayHourlyData(hour: "12",
                                                      icon: UIImage(systemName: "sun.max.fill"),
                                                      temp: 15),
                                        DayHourlyData(hour: "13",
                                                      icon: UIImage(systemName: "sun.max.fill"),
                                                      temp: 15),
                                        DayHourlyData(hour: "14",
                                                      icon: UIImage(systemName: "sun.max.fill"),
                                                      temp: 15),
                                        DayHourlyData(hour: "15",
                                                      icon: UIImage(systemName: "sun.max.fill"),
                                                      temp: 15),
                                        DayHourlyData(hour: "16",
                                                      icon: UIImage(systemName: "sun.max.fill"),
                                                      temp: 15),
                                        DayHourlyData(hour: "17",
                                                      icon: UIImage(systemName: "sun.max.fill"),
                                                      temp: 15),
                                     ]),
                     dayData: [
                        DayData(title: "Today",
                                image: UIImage(systemName: "sun.max.fill"),
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                        DayData(title: "SU",
                                image: UIImage(systemName: "sun.max.fill"),
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                        DayData(title: "MO",
                                image: UIImage(systemName: "sun.max.fill"),
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                        DayData(title: "TU",
                                image: UIImage(systemName: "sun.max.fill"),
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                        DayData(title: "WE",
                                image: UIImage(systemName: "sun.max.fill"),
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                        DayData(title: "TH",
                                image: UIImage(systemName: "sun.max.fill"),
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                        DayData(title: "FR",
                                image: UIImage(systemName: "sun.max.fill"),
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                        DayData(title: "SA",
                                image: UIImage(systemName: "sun.max.fill"),
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                     ]),
            // MARK: - MOCK Data for second city
            MOCKData(titleData: TitleData(title: "MOSCOW",
                                          subtitle: "16:42",
                                          currentTemp: 19,
                                          description: "Clear sky",
                                          minTemp: 15,
                                          maxTemp: 22),
                     dayHourlyData: (description: "Cloudy weather from 9:00 to 19:00, mostly sunny weather is expected at 12:00",
                                     data: [
                                        DayHourlyData(hour: "Now",
                                                      icon: UIImage(systemName: "sun.max.fill"),
                                                      temp: 15),
                                        DayHourlyData(hour: "09",
                                                      icon: UIImage(systemName: "sun.max.fill"),
                                                      temp: 15),
                                        DayHourlyData(hour: "10",
                                                      icon: UIImage(systemName: "sun.max.fill"),
                                                      temp: 15),
                                        DayHourlyData(hour: "11",
                                                      icon: UIImage(systemName: "sun.max.fill"),
                                                      temp: 15),
                                        DayHourlyData(hour: "12",
                                                      icon: UIImage(systemName: "sun.max.fill"),
                                                      temp: 15),
                                        DayHourlyData(hour: "13",
                                                      icon: UIImage(systemName: "sun.max.fill"),
                                                      temp: 15),
                                        DayHourlyData(hour: "14",
                                                      icon: UIImage(systemName: "sun.max.fill"),
                                                      temp: 15),
                                        DayHourlyData(hour: "15",
                                                      icon: UIImage(systemName: "sun.max.fill"),
                                                      temp: 15),
                                        DayHourlyData(hour: "16",
                                                      icon: UIImage(systemName: "sun.max.fill"),
                                                      temp: 15),
                                        DayHourlyData(hour: "17",
                                                      icon: UIImage(systemName: "sun.max.fill"),
                                                      temp: 15),
                                     ]),
                     dayData: [
                        DayData(title: "Today",
                                image: UIImage(systemName: "sun.max.fill"),
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                        DayData(title: "SU",
                                image: UIImage(systemName: "sun.max.fill"),
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                        DayData(title: "MO",
                                image: UIImage(systemName: "sun.max.fill"),
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                        DayData(title: "TU",
                                image: UIImage(systemName: "sun.max.fill"),
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                        DayData(title: "WE",
                                image: UIImage(systemName: "sun.max.fill"),
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                        DayData(title: "TH",
                                image: UIImage(systemName: "sun.max.fill"),
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                        DayData(title: "FR",
                                image: UIImage(systemName: "sun.max.fill"),
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                        DayData(title: "SA",
                                image: UIImage(systemName: "sun.max.fill"),
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                     ]),
            // MARK: - MOCK Data for third city
            MOCKData(titleData: TitleData(title: "PARIS",
                                          subtitle: "14:42",
                                          currentTemp: 19,
                                          description: "Clear sky",
                                          minTemp: 15,
                                          maxTemp: 22),
                     dayHourlyData: (description: "Cloudy weather from 9:00 to 19:00, mostly sunny weather is expected at 12:00",
                                     data: [
                                        DayHourlyData(hour: "Now",
                                                      icon: UIImage(systemName: "sun.max.fill"),
                                                      temp: 15),
                                        DayHourlyData(hour: "09",
                                                      icon: UIImage(systemName: "sun.max.fill"),
                                                      temp: 15),
                                        DayHourlyData(hour: "10",
                                                      icon: UIImage(systemName: "sun.max.fill"),
                                                      temp: 15),
                                        DayHourlyData(hour: "11",
                                                      icon: UIImage(systemName: "sun.max.fill"),
                                                      temp: 15),
                                        DayHourlyData(hour: "12",
                                                      icon: UIImage(systemName: "sun.max.fill"),
                                                      temp: 15),
                                        DayHourlyData(hour: "13",
                                                      icon: UIImage(systemName: "sun.max.fill"),
                                                      temp: 15),
                                        DayHourlyData(hour: "14",
                                                      icon: UIImage(systemName: "sun.max.fill"),
                                                      temp: 15),
                                        DayHourlyData(hour: "15",
                                                      icon: UIImage(systemName: "sun.max.fill"),
                                                      temp: 15),
                                        DayHourlyData(hour: "16",
                                                      icon: UIImage(systemName: "sun.max.fill"),
                                                      temp: 15),
                                        DayHourlyData(hour: "17",
                                                      icon: UIImage(systemName: "sun.max.fill"),
                                                      temp: 15),
                                     ]),
                     dayData: [
                        DayData(title: "Today",
                                image: UIImage(systemName: "sun.max.fill"),
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                        DayData(title: "SU",
                                image: UIImage(systemName: "sun.max.fill"),
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                        DayData(title: "MO",
                                image: UIImage(systemName: "sun.max.fill"),
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                        DayData(title: "TU",
                                image: UIImage(systemName: "sun.max.fill"),
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                        DayData(title: "WE",
                                image: UIImage(systemName: "sun.max.fill"),
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                        DayData(title: "TH",
                                image: UIImage(systemName: "sun.max.fill"),
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                        DayData(title: "FR",
                                image: UIImage(systemName: "sun.max.fill"),
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                        DayData(title: "SA",
                                image: UIImage(systemName: "sun.max.fill"),
                                minTemp: 9,
                                maxTemp: 22,
                                minDayTemp: 11,
                                maxDayTemp: 20,
                                currentTemt: 15),
                     ])
        ]
    }
}
