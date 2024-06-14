//
//  CityView.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 04.05.2024.
//

import UIKit
import SnapKit

final class CityViewCell: BaseCollectionViewCell {
    // MARK: Properties
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let tempLabel = UILabel()
    private let descriptionLable = UILabel()
    private let tempLimitsLabel = UILabel()

    // MARK: Lifecycle
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

    // MARK: Setup UI
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

    // MARK: Public methods
    func setup(_ data: TitleViewData) {
        titleLabel.text = data.title
        subtitleLabel.text = data.subtitle
        subtitleLabel.isHidden = data.subtitle == nil
        tempLabel.text = data.currentTemp?.formatedTemp()
        descriptionLable.text = data.description

        if let maxTemp = data.maxTemp, let minTemp = data.minTemp {
            tempLimitsLabel.text = "Max: \(maxTemp.formatedTemp()), min: \(minTemp.formatedTemp())"
        }
    }
}

