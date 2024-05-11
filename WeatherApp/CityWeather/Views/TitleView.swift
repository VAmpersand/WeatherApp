//
//  TitleView.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 01.05.2024.
//

import UIKit
import SnapKit

extension TitleView {
    struct InputModel {
        let title: String
        let subtitle: String?
        let currentTemp: Int
        let description: String
        let minTemp: Int
        let maxTemp: Int
    }
}

final class TitleView: BaseView {
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let tempLabel = UILabel()
    private let descriptionLable = UILabel()
    private let tempLimitsLabel = UILabel()
    
    override func setup() {
        super.setup()

        setupStackView()
        setupTitleLabel()
        setupSubitleLabel()
        setupTempLabel()
        setupDescriptionLable()
        setupTempLimitsLabel()
    }

    func setup(_ model: InputModel) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        subtitleLabel.isHidden = model.subtitle == nil
        tempLabel.text = "\(model.currentTemp)º"
        descriptionLable.text = model.description
        tempLimitsLabel.text = "Max: \(model.maxTemp)º, min: \(model.minTemp)º"
    }
    
    private func setupStackView() {
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fillProportionally
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupTitleLabel() {
        stackView.addArrangedSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
    }
    
    private func setupSubitleLabel() {
        stackView.addArrangedSubview(subtitleLabel)
        subtitleLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = .white
    }
    
    private func setupTempLabel() {
        stackView.addArrangedSubview(tempLabel)
        tempLabel.font = UIFont.systemFont(ofSize: 92, weight: .thin)
        tempLabel.textAlignment = .center
        tempLabel.textColor = .white
    }
    
    private func setupDescriptionLable() {
        stackView.addArrangedSubview(descriptionLable)
        descriptionLable.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        descriptionLable.textAlignment = .center
        descriptionLable.textColor = .white
        descriptionLable.numberOfLines = 2
    }
    
    private func setupTempLimitsLabel() {
        stackView.addArrangedSubview(tempLimitsLabel)
        tempLimitsLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        tempLimitsLabel.textAlignment = .center
        tempLimitsLabel.textColor = .white
    }
}
