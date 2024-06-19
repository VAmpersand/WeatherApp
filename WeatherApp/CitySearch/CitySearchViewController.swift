//
//  CitySearchViewController.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 15.05.2024.
//

import UIKit
import SnapKit

protocol CitySearchViewControllerDelegate: AnyObject {
    func reloadData()
}

final class CitySearchViewController: BaseViewController {
    // MARK: Properties
    private let tableView = UITableView()

    private let cityCellId = "cell"

    weak var delegate: CitySearchViewControllerDelegate?
    var viewModel: CitySearchViewModelInput!
    var cityList: [CityData] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    var searchQuery: String = ""

    // MARK: Lifecycle
    override func setup() {
        super.setup()

        setupTableView()

        viewModel.output = self
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

    // MARK: Private methods
    private func getAttributedTitle(for indexPath: IndexPath) -> NSAttributedString? {
        let city = cityList[indexPath.row]

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

    // MARK: Public methods
}

// MARK: - UISearchResultsUpdating
extension CitySearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.searchTextField.text else { return }
        let searchQuery = query.lowercased()

        view.backgroundColor = .black.withAlphaComponent(searchQuery.isEmpty ? 0.5 : 1)
        viewModel.filterCity(with: searchQuery)
    }
}

// MARK: - UITableViewDataSource
extension CitySearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cityList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cityCellId, for: indexPath)

        cell.textLabel?.attributedText = getAttributedTitle(for: indexPath)
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
        viewModel.select(cityList[indexPath.row])
        delegate?.reloadData()
        dismiss(animated: true)
    }
}

// MARK: - CitySearchViewModelOutput
extension CitySearchViewController: CitySearchViewModelOutput {

}
