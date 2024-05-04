//
//  ViewController.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 01.05.2024.
//

import UIKit
import SnapKit

final class WeatherViewController: BaseViewController {
    private let backgroundImage = UIImageView()
    private let titleContainer = UIView()
    private let titleView = TitleView()
    private let bottomBarView = BottomBarView()

    private let temporaryContentView = UIView()
    private let dayWeatherView = DayWeatherView()
    private let hourlyWeaterView = DayHourlyWeatherView()
    private let searchField = UISearchTextField()
    private let cityView = CityView()

    override func setup() {
        super.setup()
        
        view.backgroundColor = .white

        setupBackgroundImage()
        setupTitleContainer()
        setupTitleView()
        setupBottomBarView()

        setupTemporaryContentView()
        setupDayWeatherView()
        setupDayWeaterView()
        setupSearchField()
        setupCityView()
    }

    private func setupBackgroundImage() {
        view.addSubview(backgroundImage)
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.image = UIImage(named: "clearSky")

        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupTitleContainer() {
        view.addSubview(titleContainer)

        titleContainer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(titleContainer.snp.width).multipliedBy(0.7)
        }
    }

    private func setupTitleView() {
        titleContainer.addSubview(titleView)
        titleView.setup(
            TitleView.InputModel(title: "Current palce",
                                 subtitle: "BUENOS AIRES",
                                 currentTemp: 19,
                                 description: "Clear sky",
                                 minTemp: 15,
                                 maxTemp: 22)
        )

        titleView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }

    private func setupBottomBarView() {
        view.addSubview(bottomBarView)

        bottomBarView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(60)
        }
    }

    private func setupTemporaryContentView() {
        view.addSubview(temporaryContentView)

        temporaryContentView.backgroundColor = .black// UIColor(named: "lightBlue")
        temporaryContentView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        temporaryContentView.layer.borderWidth = 1
        temporaryContentView.layer.cornerRadius = 15

        temporaryContentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(titleContainer.snp.bottom).offset(20)
        }
    }

    private func setupDayWeatherView() {
        temporaryContentView.addSubview(dayWeatherView)
        dayWeatherView.setup(
            DayWeatherView.InputModel(title: "Now",
                                      image: UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysOriginal),
                                      minTemp: 13,
                                      maxTemp: 25,
                                      minDayTemp: 15,
                                      maxDayTemp: 22,
                                      currentTemt: 16)
        )

        dayWeatherView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    private func setupDayWeaterView() {
        temporaryContentView.addSubview(hourlyWeaterView)
        hourlyWeaterView.setup(
            [
                DayHourlyWeatherView.InputModel(hour: "Now",
                                             icon: UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysOriginal),
                                             temp: 19),
                DayHourlyWeatherView.InputModel(hour: "12",
                                             icon: UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysOriginal),
                                             temp: 19),
                DayHourlyWeatherView.InputModel(hour: "13",
                                             icon: UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysOriginal),
                                             temp: 19),
                DayHourlyWeatherView.InputModel(hour: "14",
                                             icon: UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysOriginal),
                                             temp: 19),
                DayHourlyWeatherView.InputModel(hour: "15",
                                             icon: UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysOriginal),
                                             temp: 19),
                DayHourlyWeatherView.InputModel(hour: "16",
                                             icon: UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysOriginal),
                                             temp: 19),
                DayHourlyWeatherView.InputModel(hour: "17",
                                             icon: UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysOriginal),
                                             temp: 19),
                DayHourlyWeatherView.InputModel(hour: "18",
                                             icon: UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysOriginal),
                                             temp: 19),
                DayHourlyWeatherView.InputModel(hour: "19",
                                             icon: UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysOriginal),
                                             temp: 19),
            ]
        )

        hourlyWeaterView.snp.makeConstraints { make in
            make.top.equalTo(dayWeatherView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(100)
        }
    }

    private func setupSearchField() {
        temporaryContentView.addSubview(searchField)

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
            make.top.equalTo(hourlyWeaterView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
    }

    private func setupCityView() {
        temporaryContentView.addSubview(cityView)
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
            make.bottom.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
