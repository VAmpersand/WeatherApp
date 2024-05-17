//
//  CitySearchViewController.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 15.05.2024.
//

import UIKit
import SnapKit

final class CitySearchViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension CitySearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.searchTextField.text else { return }

        view.backgroundColor = .black.withAlphaComponent(text.isEmpty ? 0.5 : 1)

        print(text)
    }
}
