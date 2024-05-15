//
//  CitySelectionViewController.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 08.05.2024.
//

import UIKit
import SnapKit

final class CitySelectionViewController: BaseViewController {
    private let searchField = UISearchTextField()
    private let cityView = CityView()

    private let showHideUnitSelectionButton = UIButton()
    private let unitSelectionView = UnitSelectionView()
    private let showWebViewButton = UIButton()

    override func setup() {
        super.setup()

        view.backgroundColor = .black

        setupSearchField()
        setupCityView()

        setupShowHideUnitSelectionButton()
        setupUnitSelectionView()
        setupShowWebViewButton()
    }

    private func setupNavigationBar() {
//        navigationItem.lar
    }

    private func setupSearchField() {
        view.addSubview(searchField)

        let tintColor = UIColor.white.withAlphaComponent(0.5)
        searchField.attributedPlaceholder = NSAttributedString(
            string:  "Search city or airport",
            attributes: [.foregroundColor: tintColor]
        )
        searchField.backgroundColor = .white.withAlphaComponent(0.1)
        searchField.tintColor = .white
        searchField.leftView?.tintColor = tintColor

        let rightView = UIButton()
        rightView.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        rightView.tintColor = tintColor
        rightView.addAction(UIAction { _ in
            print("rightView action")
        }, for: .touchUpInside)

        searchField.rightView = rightView
        searchField.rightViewMode = .unlessEditing

        searchField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
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
            make.top.equalTo(searchField.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    private func setupShowHideUnitSelectionButton() {
        view.addSubview(showHideUnitSelectionButton)

        showHideUnitSelectionButton.setTitle("Show UnitSelection", for: .normal)
        showHideUnitSelectionButton.setTitleColor(.black, for: .normal)
        showHideUnitSelectionButton.backgroundColor = .white.withAlphaComponent(0.6)
        showHideUnitSelectionButton.layer.cornerRadius = 8

        showHideUnitSelectionButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }

            unitSelectionView.isHidden.toggle()

            let buttonTitle = unitSelectionView.isHidden ? "Show UnitSelection" : "Hide UnitSelection"
            showHideUnitSelectionButton.setTitle(buttonTitle, for: .normal)
        }, for: .touchUpInside)

        showHideUnitSelectionButton.snp.makeConstraints { make in
            make.top.equalTo(cityView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(40)
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
            make.top.equalTo(showHideUnitSelectionButton.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
    }
}
