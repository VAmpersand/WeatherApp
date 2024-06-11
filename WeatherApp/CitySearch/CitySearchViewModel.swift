//
//  CitySearchViewModel.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 08.06.2024.
//

import UIKit

protocol CitySearchViewModelInput {
    var output: CitySearchViewModelOutput? { get set }

    func filterCity(with searchQuery: String)
    func getAttributedTitle(for indexPath: IndexPath) -> NSAttributedString?
}

protocol CitySearchViewModelOutput: AnyObject {
    var cityList: [CityData] { get set }
}


final class CitySearchViewModel: CitySearchViewModelInput {
    weak var output: CitySearchViewModelOutput?

    private let cityListProvider: CityListProvider
    private var searchQuery = ""

    init(cityListProvider: CityListProvider) {
        self.cityListProvider = cityListProvider

        output?.cityList = cityListProvider.cityList
    }

    func filterCity(with searchQuery: String) {
        self.searchQuery = searchQuery

        if searchQuery.isEmpty {
            output?.cityList = []
        } else {
            output?.cityList = cityListProvider.cityList.filter {
                $0.name.lowercased().contains(searchQuery)
                || $0.country.lowercased().contains(searchQuery)
                || $0.state.lowercased().contains(searchQuery)
            }
        }
    }

    func getAttributedTitle(for indexPath: IndexPath) -> NSAttributedString? {
        guard let city = output?.cityList[indexPath.row] else { return nil }

        var title = "\(city.name), \(city.country)"
        if !city.state.isEmpty { title += ", \(city.state)" }

        let attributedText = NSMutableAttributedString(
            string: title,
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        )

        let queryRange = (title.lowercased() as NSString).range(of: searchQuery)
        attributedText.addAttributes([.foregroundColor: UIColor.white], range: queryRange)
        
        return attributedText
    }
}
