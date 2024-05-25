//
//  CityWeatherViewController.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 01.05.2024.
//

import UIKit
import SnapKit

final class CityWeatherViewController: BaseViewController {
    // MARK: Properties
    private let backgroundImage = UIImageView()
    private let titleContainer = UIView()
    private let titleView = TitleView()
    private let bottomBarView = BottomBarView()

    private let temporaryContentView = UIView()
    private let showDelailsButton = UIButton()

    // MARK: Lifecycle
    override func setup() {
        super.setup()
        
        view.backgroundColor = .white

        setupBackgroundImage()
        setupTitleContainer()
        setupTitleView()
        setupBottomBarView()

        setupTemporaryContentView()
        setupShowDetailsButton()
    }

    // MARK: Setup UI
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

        titleView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }

    private func setupBottomBarView() {
        view.addSubview(bottomBarView)
        bottomBarView.cityListButtonAction = { [weak self] in
            self?.dismiss(animated: true)
        }

        bottomBarView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(60)
        }
    }

    private func setupTemporaryContentView() {
        view.addSubview(temporaryContentView)

        temporaryContentView.backgroundColor = .black
        temporaryContentView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        temporaryContentView.layer.borderWidth = 1
        temporaryContentView.layer.cornerRadius = 15

        temporaryContentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(titleContainer.snp.bottom).offset(20)
        }
    }

    private func setupShowDetailsButton() {
        temporaryContentView.addSubview(showDelailsButton)
        showDelailsButton.setTitle("Show details", for: .normal)
        showDelailsButton.setTitleColor(.white, for: .normal)
        showDelailsButton.backgroundColor = .white.withAlphaComponent(0.3)
        showDelailsButton.layer.cornerRadius = 5
        showDelailsButton.addAction(UIAction { [weak self] _ in
            let detailsViewController = CityWeatherDetailedViewController()
            let navigationController = BaseNavigationController(rootViewController: detailsViewController)
            detailsViewController.setupNavigationBar(
                withTitle: "Weather conditions",
                andIcon: UIImage(systemName: "cloud.sun.fill")
            )
            self?.present(navigationController, animated: true)
        }, for: .touchUpInside)

        showDelailsButton.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
    }

    // MARK: Public methods
    func setup(_ data: MOCKData) {
        titleView.setup(data.titleData)
    }
}
