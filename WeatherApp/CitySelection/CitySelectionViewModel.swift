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
}

protocol CitySelectionViewModelOutput: AnyObject {
    var sections: [CitySelectionViewModel.Section] { get set }
}

extension CitySelectionViewModel {
    struct Section: Hashable {
        let items: [Item]
        let footerAttributedString: NSAttributedString?
    }
}

final class CitySelectionViewModel: CitySelectionViewModelInput {
    typealias Item = CityWeatherData

    private let weatherData = CityWeatherData.mockData

    weak var output: CitySelectionViewModelOutput?

    func viewDidLoad() {
        prepareSections()
    }

    private func prepareSections() {
        output?.sections = [Section(items: weatherData, footerAttributedString: createFooterString())]
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
