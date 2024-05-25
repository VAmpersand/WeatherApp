//
//  CitySearchViewController.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 15.05.2024.
//

import UIKit
import SnapKit

final class CitySearchViewController: BaseViewController {
    // MARK: Properties
    private let tableView = UITableView()

    private let cityCellId = "cell"
    private let cityList = [
        "Moscow",
        "Paris",
        "Lonon",
        "Buenos Aires",
        "Tokio",
        "Beijing",
        "Delhi",
        "Berlin",
        "Oslo",
        "Minsk",
        "Bangkok"
    ] // MOCK data

    private var filteredCityList: [String] = []
    private var searchQuery = ""


    // MARK: Lifecycle
    override func setup() {
        super.setup()

        setupTableView()
    }

    // MARK: Setup UI
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cityCellId)

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }

    // MARK: Public methods
}

// MARK: - UISearchResultsUpdating
extension CitySearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.searchTextField.text else { return }
        self.searchQuery = query.lowercased()

        view.backgroundColor = .black.withAlphaComponent(searchQuery.isEmpty ? 0.5 : 1)

        filteredCityList = cityList.filter { $0.lowercased().contains(searchQuery) }
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension CitySearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredCityList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cityCellId, for: indexPath)

        let cityName = filteredCityList[indexPath.row]
        let attributedText = NSMutableAttributedString(
            string: cityName,
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        )

        let queryRange = (cityName.lowercased() as NSString).range(of: searchQuery)
        attributedText.addAttributes([.foregroundColor: UIColor.white], range: queryRange)

        cell.textLabel?.attributedText = attributedText
        cell.imageView?.image = UIImage()
        cell.backgroundColor = .clear

        let bgColorView = UIView()
        bgColorView.backgroundColor = .white.withAlphaComponent(0.3)
        cell.selectedBackgroundView = bgColorView

        return cell
    }
}

// MARK: - UITableViewDelegate
extension CitySearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(filteredCityList[indexPath.row])
    }
}
