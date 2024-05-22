//
//  CitySelectionViewController.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 08.05.2024.
//

import UIKit
import SnapKit

final class CitySelectionViewController: BaseViewController {
    // MARK: - Properties
    private let tempStackView = UIStackView()
    private let unitSelectionView = UnitSelectionView()
    private let showWebViewButton = UIButton()

    // MARK: - Lifecycle
    override func setup() {
        super.setup()

        view.backgroundColor = .black
        title = "Weather"

        setupNavigationBar()
        presentCityWeather(with: MOCKData.data.first, animated: false)

        setupTempStackView()
        setupUnitSelectionView()
        setupShowWebViewButton()
    }

    // MARK: - Setup UI
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
            action: #selector(rightBarButtonAction))
    }

    private func setupTempStackView() {
        view.addSubview(tempStackView)
        tempStackView.axis = .vertical
        tempStackView.spacing = 12

        MOCKData.data.forEach { data in
            let cityView = CityView()
            cityView.setup(CityView.InputModel(title: data.titleData.title,
                                               subtitle: data.titleData.subtitle,
                                               currentTemp: data.titleData.currentTemp,
                                               description: data.titleData.description,
                                               minTemp: data.titleData.minTemp,
                                               maxTemp: data.titleData.maxTemp))

            cityView.tapAction = { [weak self] in self?.presentCityWeather(with: data) }
            tempStackView.addArrangedSubview(cityView)
        }

        tempStackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }

    private func setupUnitSelectionView() {
        view.addSubview(unitSelectionView)

        unitSelectionView.backgroundColor = .white.withAlphaComponent(0.8)
        unitSelectionView.isHidden = true

        unitSelectionView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(100)
        }
    }

    private func setupShowWebViewButton() {
        view.addSubview(showWebViewButton)

        showWebViewButton.setTitle("Show Info", for: .normal)
        showWebViewButton.setTitleColor(.black, for: .normal)
        showWebViewButton.backgroundColor = .white.withAlphaComponent(0.6)
        showWebViewButton.layer.cornerRadius = 8

        showWebViewButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }

            let webViewController = WebViewController()
            if let url = URL(string: "https://meteoinfo.ru/t-scale") {
                webViewController.open(url)
            }
            webViewController.title = "Info"
            let navigationController = BaseNavigationController(rootViewController: webViewController)
            present(navigationController, animated: true)
        }, for: .touchUpInside)

        showWebViewButton.snp.makeConstraints { make in
            make.top.equalTo(tempStackView.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
    }

    private func presentCityWeather(with data: MOCKData?, animated: Bool = true) {
        let viewController = CityWeatherViewController()
        viewController.modalPresentationStyle = .fullScreen
        if let data {
            viewController.setup(data)
        }
        present(viewController, animated: animated)
    }

    @IBAction private func rightBarButtonAction() {
        unitSelectionView.isHidden.toggle()
    }

    // MARK: - Public methods
}

// MARK: - UISearchBarDelegate
extension CitySelectionViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarBookmarkButtonClicked")
    }
}
