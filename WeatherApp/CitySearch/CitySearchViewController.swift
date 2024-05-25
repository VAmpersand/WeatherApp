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
        tableView.contentInset.left = 16
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let attributedText = NSMutableAttributedString(
            string: filteredCityList[indexPath.row],
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        )

        let queryRange = (filteredCityList[indexPath.row].lowercased() as NSString).range(of: searchQuery)
        attributedText.addAttributes([.foregroundColor: UIColor.white], range: queryRange)

        cell.backgroundColor = .clear
        cell.textLabel?.attributedText = attributedText

        return cell
    }
}

// MARK: - UITableViewDelegate
extension CitySearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
