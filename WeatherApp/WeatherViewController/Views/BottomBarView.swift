//
//  BottomBarView.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 01.05.2024.
//

import UIKit
import SnapKit

final class BottomBarView: UIView {

    private let deviderView = UIView()
    private let cityListButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor(named: "lightBlue")
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 15

        setupDeviderView()
        setupCityListButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupDeviderView() {
        addSubview(deviderView)
        deviderView.backgroundColor = .white.withAlphaComponent(0.3)

        deviderView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
    }

    private func setupCityListButton() {
        addSubview(cityListButton)
        cityListButton.setImage(
            UIImage(systemName: "list.bullet",
                    withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)), 
            for: .normal
        )
        cityListButton.tintColor = .white

        cityListButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(40)
        }
    }
}
