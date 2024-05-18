//
//  CityWeatherDetailedViewController.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 15.05.2024.
//

import UIKit
import SnapKit

final class CityWeatherDetailedViewController: BaseViewController {
    // MARK: - Properties

    // MARK: - Lifecycle
    override func setup() {
        super.setup()

        view.backgroundColor = .waDarkGray

        setupCloseButton()
    }

    // MARK: - Setup UI
    func setupNavigationBar(withTitle title: String, andIcon icon: UIImage?) {
        let iconView = UIImageView(image: icon?.withTintColor(.white, renderingMode: .alwaysOriginal))

        let lable = UILabel()
        lable.text = title
        lable.textColor = .white

        let titleStackView = UIStackView(arrangedSubviews: [iconView, lable])
        titleStackView.spacing = 6

        navigationItem.titleView = titleStackView
    }

    // MARK: - Public methods
}