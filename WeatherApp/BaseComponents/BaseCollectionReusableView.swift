//
//  BaseCollectionReusableView.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 01.06.2024.
//

import UIKit

class BaseCollectionReusableView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        super.init(frame: .zero)

        setup()
    }

    func setup() {}
}
