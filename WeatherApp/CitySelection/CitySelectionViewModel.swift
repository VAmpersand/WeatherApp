//
//  CitySelectionViewModel.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 01.06.2024.
//

import UIKit

protocol CitySelectionViewModelInput {
    var output: CitySelectionViewModelOutput? { get set }

    func viewDidLoad()
    func getForecastForCity(with id: Int?)
}

protocol CitySelectionViewModelOutput: AnyObject {
    var sections: [CitySelectionViewModel.Section] { get set }

    func setupForecast(_ forecast: CityWeatherData)
}

extension CitySelectionViewModel {
    struct Section: Hashable {
        let items: [CityWeatherData]
        let footerAttributedString: NSAttributedString?
    }
}

final class CitySelectionViewModel: CitySelectionViewModelInput {
    weak var output: CitySelectionViewModelOutput?
    private var weatherProvider: WeatherProvider?

    init(weatherProvider: WeatherProvider) {
        self.weatherProvider = weatherProvider
        self.weatherProvider?.delegate = self
    }

    func viewDidLoad() {
        prepareSections(with: weatherProvider?.weatherDataCache ?? [])
    }

    func getForecastForCity(with id: Int?) {
        guard let id else { return }
        weatherProvider?.getForecastForCity(with: id) { [weak self] forecast in

            let cityForecast = CityWeatherData(
                id: id,
                titleData: TitleViewData(title: "Current palce",
                                         subtitle: "BUENOS AIRES",
                                         currentTemp: "19",
                                         description: "Clear sky",
                                         minTemp: "15",
                                         maxTemp: "22"),
                dayHourlyDescription: "Cloudy weather from 9:00 to 19:00, mostly sunny weather is expected at 12:00",
                dayHourlyData:[
                    DayHourlyViewData(hour: "Now Now Now",
                                      imageSystemName: "sun.max.fill",
                                      temp: 15),
                    DayHourlyViewData(hour: "09",
                                      imageSystemName: "sun.max.fill",
                                      temp: 15),
                    DayHourlyViewData(hour: "10",
                                      imageSystemName: "sun.max.fill",
                                      temp: 15),
                    DayHourlyViewData(hour: "11",
                                      imageSystemName: "sun.max.fill",
                                      temp: 15),
                    DayHourlyViewData(hour: "12",
                                      imageSystemName: "sun.max.fill",
                                      temp: 15),
                    DayHourlyViewData(hour: "13",
                                      imageSystemName: "sun.max.fill",
                                      temp: 15),
                    DayHourlyViewData(hour: "14",
                                      imageSystemName: "sun.max.fill",
                                      temp: 15),
                    DayHourlyViewData(hour: "15",
                                      imageSystemName: "sun.max.fill",
                                      temp: 15),
                    DayHourlyViewData(hour: "16",
                                      imageSystemName: "sun.max.fill",
                                      temp: 15),
                    DayHourlyViewData(hour: "17",
                                      imageSystemName: "sun.max.fill",
                                      temp: 15),
                ],
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
                ])
            self?.output?.setupForecast(cityForecast)

        } errorHandler: { error in
            print(#function, error.description)
        }
    }

    private func prepareSections(with data: [CityWeatherData]) {
        output?.sections = [Section(items: data, footerAttributedString: createFooterString())]
    }

    private func createFooterString() -> NSAttributedString {
        let text = "Learn more about meteorological data"
        let attributedString = NSMutableAttributedString(
            string: text,
            attributes: [.foregroundColor: UIColor.gray])

        if let url = URL(string: "https://meteoinfo.ru/t-scale") {
            let linkRange = (text as NSString).range(of: "meteorological data")

            attributedString.addAttributes([.link: url], range: linkRange)
        }

        return attributedString
    }
}

// MARK: - WeatherProviderDelegate
extension CitySelectionViewModel: WeatherProviderDelegate {
    func setCurrentWeather(_ data: [CityWeatherData]) {
        prepareSections(with: data)
    }
}
