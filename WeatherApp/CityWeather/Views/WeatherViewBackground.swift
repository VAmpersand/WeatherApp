//
//  WeatherViewBackground.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 01.06.2024.
//

import UIKit
import SnapKit

final class WeatherViewBackground: BaseCollectionReusableView {
    static let identifire = String(describing: WeatherViewBackground.self)
    // MARK: Properties

    // MARK: Lifecycle
    override func setup() {
        super.setup()

        backgroundColor = .waLightBlue
        layer.cornerRadius = 16
    }

    // MARK: Setup UI

    // MARK: Public methods
    func setup(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
    }
}
