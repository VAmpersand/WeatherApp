//
//  CitySelectionViewController.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 08.05.2024.
//

import UIKit
import SnapKit

final class CitySelectionViewController: BaseViewController {
    // MARK: Properties
    private let tableView = UITableView()
    private let unitSelectionView = UnitSelectionView()

    private let dataSource = MOCKData.data

    // MARK: Lifecycle
    override func setup() {
        super.setup()

        view.backgroundColor = .black
        title = "Weather"

        setupNavigationBar()
        setupUnitSelectionView()
        setupTableView()

        presentCityWeather(with: dataSource.first, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height {
            unitSelectionView.snp.updateConstraints { make in
                make.top.equalToSuperview().offset(statusBarHeight + 50)
            }
        }
    }

    // MARK: Setup UI
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true

        let citySearchViewController = CitySearchViewController()
        let searchController = UISearchController(searchResultsController: citySearchViewController)
        searchController.searchResultsUpdater = citySearchViewController
        searchController.searchBar.searchTextField.placeholder = "Search city or airport"
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage(UIImage(systemName: "list.bullet"),
                                            for: .bookmark,
                                            state: .normal)
        searchController.searchBar.delegate = self
        searchController.showsSearchResultsController = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: self,
            action: #selector(rightBarButtonAction)
        )
    }

    private func setupUnitSelectionView() {
        navigationController?.view.addSubview(unitSelectionView)
        unitSelectionView.isHidden = true
        unitSelectionView.delegate = self

        unitSelectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().inset(16)
        }
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 120
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }

    // MARK: Private methods
    private func presentCityWeather(with data: MOCKData?, animated: Bool = true) {
        let viewController = CityWeatherViewController()
        viewController.viewModel = CityWeatherViewModel(with: data)
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: animated)
    }

    @IBAction private func rightBarButtonAction() {
        unitSelectionView.isHidden.toggle()
    }

    // MARK: Public methods
}

// MARK: - UISearchBarDelegate
extension CitySelectionViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarBookmarkButtonClicked")
    }
}

// MARK: - UnitSelectionViewDelegate
extension CitySelectionViewController: UnitSelectionViewDelegate {
    func didSelectUnit(_ unit: TempUnit) {
        unitSelectionView.isHidden = true
        
        print("Selected unit -", unit.unitLabel)
    }
    
    func showUnitInfo() {
        unitSelectionView.isHidden = true

        let webViewController = WebViewController()
        if let url = URL(string: "https://meteoinfo.ru/t-scale") {
            webViewController.open(url)
        }
        webViewController.title = "Info"
        let navigationController = BaseNavigationController(rootViewController: webViewController)
        present(navigationController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension CitySelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let data = dataSource[indexPath.row]
        let cityView = CityView() // TODO: - Temp implementation. Need use custom cell
        cityView.setup(CityView.InputModel(title: data.titleData.title,
                                           subtitle: data.titleData.subtitle,
                                           currentTemp: data.titleData.currentTemp,
                                           description: data.titleData.description,
                                           minTemp: data.titleData.minTemp,
                                           maxTemp: data.titleData.maxTemp))


        cell.addSubview(cityView)
        cityView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
        }

        cell.selectionStyle = .none
        cell.backgroundColor = .clear

        return cell
    }
}

// MARK: - UITableViewDelegate
extension CitySelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentCityWeather(with: dataSource[indexPath.row])
    }
}
