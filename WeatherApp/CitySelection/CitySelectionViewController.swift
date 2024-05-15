//
//  CitySelectionViewController.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 08.05.2024.
//

import UIKit
import SnapKit

final class CitySelectionViewController: BaseViewController {
    private let cityView = CityView()

    private let unitSelectionView = UnitSelectionView()
    private let showWebViewButton = UIButton()

    override func setup() {
        super.setup()

        view.backgroundColor = .black
        title = "Weather"

        setupNavigationBar()
        setupCityView()

        setupUnitSelectionView()
        setupShowWebViewButton()
    }

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

    private func setupCityView() {
        view.addSubview(cityView)
        cityView.setup(
            CityView.InputModel(title: "Current palce",
                                subtitle: "Bueos Aires",
                                currentTemp: 19,
                                description: "Clear sky",
                                minTemp: 15,
                                maxTemp: 22)
        )

        cityView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
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
            make.top.equalTo(cityView.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
    }

    @IBAction private func rightBarButtonAction() {
        unitSelectionView.isHidden.toggle()
    }
}

extension CitySelectionViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarBookmarkButtonClicked")
    }
}
