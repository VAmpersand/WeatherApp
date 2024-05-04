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
    private let dayTempLimitsView = DayTempLimitsView()
    private let hourlyWeaterView = HourlyWeatherView()

    override func setup() {
        super.setup()
        
        view.backgroundColor = .white

        setupBackgroundImage()
        setupTitleContainer()
        setupTitleView()
        setupBottomBarView()

        setupTemporaryContentView()
        setupDayTempView()
        setupDayWeaterView()
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

        temporaryContentView.backgroundColor = UIColor(named: "lightBlue")
        temporaryContentView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        temporaryContentView.layer.borderWidth = 1
        temporaryContentView.layer.cornerRadius = 15

        temporaryContentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(titleContainer.snp.bottom).offset(20)
        }
    }

    private func setupDayTempView() {
        temporaryContentView.addSubview(dayTempLimitsView)

        dayTempLimitsView.setup(
            DayTempLimitsView.InputModel(minWeekTemp: 13,
                                         maxWeekTemp: 25,
                                         minDayTemp: 15,
                                         maxDayTemp: 22,
                                         currentTemt: 16)
        )

        dayTempLimitsView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.width.equalTo(200)
        }
    }

    private func setupDayWeaterView() {
        temporaryContentView.addSubview(hourlyWeaterView)

        hourlyWeaterView.setup(
            [
                HourlyWeatherView.InputModel(hour: "Now",
                                             icon: UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysOriginal),
                                             temp: 19),
                HourlyWeatherView.InputModel(hour: "12",
                                             icon: UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysOriginal),
                                             temp: 19),
                HourlyWeatherView.InputModel(hour: "13",
                                             icon: UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysOriginal),
                                             temp: 19),
                HourlyWeatherView.InputModel(hour: "14",
                                             icon: UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysOriginal),
                                             temp: 19),
                HourlyWeatherView.InputModel(hour: "15",
                                             icon: UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysOriginal),
                                             temp: 19),
                HourlyWeatherView.InputModel(hour: "16",
                                             icon: UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysOriginal),
                                             temp: 19),
                HourlyWeatherView.InputModel(hour: "17",
                                             icon: UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysOriginal),
                                             temp: 19),
                HourlyWeatherView.InputModel(hour: "18",
                                             icon: UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysOriginal),
                                             temp: 19),
                HourlyWeatherView.InputModel(hour: "19",
                                             icon: UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysOriginal),
                                             temp: 19),
            ]
        )

        hourlyWeaterView.snp.makeConstraints { make in
            make.top.equalTo(dayTempLimitsView.snp.bottom).offset(16)
            make.bottom.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(100)
        }
    }
}
