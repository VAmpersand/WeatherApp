//
//  CityView.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 04.05.2024.
//

import UIKit
import SnapKit

extension CityView {
    struct InputModel {
        let title: String
        let subtitle: String?
        let currentTemp: Int
        let description: String
        let minTemp: Int
        let maxTemp: Int
    }
}

final class CityView: BaseView {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let tempLabel = UILabel()
    private let descriptionLable = UILabel()
    private let tempLimitsLabel = UILabel()

    override func setup() {
        super.setup()

        snp.makeConstraints { make in
            make.height.equalTo(125)
        }

        setupImageView()
        setupTempLabel()
        setupTempLimitsLabel()
        setupTitleLabel()
        setupSubitleLabel()
        setupDescriptionLable()
    }

    func setup(_ model: InputModel) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        subtitleLabel.isHidden = model.subtitle == nil
        tempLabel.text = "\(model.currentTemp)º"
        descriptionLable.text = model.description
        tempLimitsLabel.text = "Max: \(model.maxTemp)º, min: \(model.minTemp)º"
    }

    private func setupImageView() {
        addSubview(imageView)
        imageView.image = UIImage(named: "clearSky")
        imageView.contentMode = .top
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupTempLabel() {
        addSubview(tempLabel)
        tempLabel.font = UIFont.systemFont(ofSize: 50, weight: .light)
        tempLabel.textColor = .white
        tempLabel.textAlignment = .right

        tempLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(6)
            make.trailing.equalToSuperview().inset(16)
        }
    }

    private func setupTempLimitsLabel() {
        addSubview(tempLimitsLabel)
        tempLimitsLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        tempLimitsLabel.textColor = .white
        tempLimitsLabel.textAlignment = .right

        tempLimitsLabel.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().inset(16)
        }
    }

    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        titleLabel.textColor = .white

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(tempLabel.snp.leading).offset(-20)
        }
    }

    private func setupSubitleLabel() {
        addSubview(subtitleLabel)
        subtitleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        subtitleLabel.textColor = .white

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(16)
        }
    }

    private func setupDescriptionLable() {
        addSubview(descriptionLable)
        descriptionLable.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        descriptionLable.textColor = .white
        descriptionLable.numberOfLines = 2

        descriptionLable.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(tempLimitsLabel.snp.leading).offset(-20)
        }
    }
}
