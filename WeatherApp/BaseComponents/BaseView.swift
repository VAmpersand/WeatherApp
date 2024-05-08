//
//  BaseView.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 04.05.2024.
//

import UIKit

class BaseView: UIView {
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
