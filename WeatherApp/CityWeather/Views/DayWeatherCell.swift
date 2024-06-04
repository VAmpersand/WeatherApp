//
//  DayWeatherCell.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 04.05.2024.
//

import UIKit
import SnapKit

final class DayWeatherCell: BaseCollectionViewCell {
    // MARK: Properties
    private let titleLabel = UILabel()
    private let iconView = UIImageView()
    private let minTempLabel = UILabel()
    private let tempLimitsView = TempLimitsView()
    private let maxTempLabel = UILabel()

    // MARK: Lifecycle
    override func setup() {
        super.setup()

        setupTitleLabel()
        setupIconView()
        setupMinTempLable()
        setupTempLimitsView()
        setupMaxTempLabel()
    }

    // MARK: Setup UI
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .white

        titleLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.equalTo(60)
        }
    }

    private func setupIconView() {
        addSubview(iconView)
        iconView.contentMode = .scaleAspectFit

        iconView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
    }

    private func setupMinTempLable() {
        addSubview(minTempLabel)
        minTempLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        minTempLabel.textAlignment = .center
        minTempLabel.textColor = .white.withAlphaComponent(0.7)

        minTempLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(30)
        }
    }

    private func setupTempLimitsView() {
        addSubview(tempLimitsView)

        tempLimitsView.snp.makeConstraints { make in
            make.leading.equalTo(minTempLabel.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
    }

    private func setupMaxTempLabel() {
        addSubview(maxTempLabel)
        maxTempLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        maxTempLabel.textAlignment = .center
        maxTempLabel.textColor = .white

        maxTempLabel.snp.makeConstraints { make in
            make.leading.equalTo(tempLimitsView.snp.trailing).offset(16)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(30)
        }
    }

    // MARK: Public methods
    func setup(_ inputModel: DayData) {
        titleLabel.text = inputModel.title
        iconView.image = UIImage(systemName: inputModel.imageSystemName)?.withRenderingMode(.alwaysOriginal)
        minTempLabel.text = "\(Int(inputModel.minDayTemp))º"
        maxTempLabel.text = "\(Int(inputModel.maxDayTemp))º"
        tempLimitsView.setup(inputModel)
    }
}

// MARK: - TempLimitsView
extension DayWeatherCell {
    final class TempLimitsView: BaseView {
        // MARK: Properties
        private let tempLimitsView = UIView()
        private let currentTempView = UIView()

        // MARK: Lifecycle
        override func setup() {
            super.setup()

            backgroundColor = .waDarkBlue.withAlphaComponent(0.5)
            layer.cornerRadius = 3

            snp.makeConstraints { make in
                make.height.equalTo(6)
            }

            setupTempLimitsView()
            setupCurrentTempView()
        }

        // MARK: Setup UI
        private func setupTempLimitsView() {
            addSubview(tempLimitsView)

            tempLimitsView.backgroundColor = .waDarkYellow
            tempLimitsView.layer.borderColor = UIColor.waDarkBlue.withAlphaComponent(0.7).cgColor
            tempLimitsView.layer.borderWidth = 1
            tempLimitsView.layer.cornerRadius = 3

            tempLimitsView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.height.equalToSuperview()
            }
        }

        private func setupCurrentTempView() {
            addSubview(currentTempView)

            currentTempView.backgroundColor = .white
            currentTempView.layer.borderColor = UIColor.waDarkBlue.withAlphaComponent(0.7).cgColor
            currentTempView.layer.borderWidth = 1
            currentTempView.layer.cornerRadius = 3

            currentTempView.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.size.equalTo(snp.height)
            }
        }

        // MARK: Public methods
        func setup(_ model: DayData) {
            let tempDiff = model.maxTemp - model.minTemp
            let minOffset = abs(model.minTemp - model.minDayTemp) / tempDiff
            let maxOffset = abs(model.maxTemp - model.maxDayTemp) / tempDiff

            tempLimitsView.snp.remakeConstraints { make in
                make.trailing.equalToSuperview().multipliedBy(1 - maxOffset)
                make.width.equalToSuperview().multipliedBy(1 - minOffset - maxOffset)
                make.height.equalToSuperview()
            }

            if let currentTemt = model.currentTemt {
                let currentTempOffset = abs(model.minTemp - currentTemt) / tempDiff

                if currentTempOffset == 0 {
                    currentTempView.snp.remakeConstraints { make in
                        make.centerX.equalTo(snp.leading)
                        make.size.equalTo(snp.height)
                    }
                } else {
                    currentTempView.snp.remakeConstraints { make in
                        make.centerX.equalTo(snp.trailing).multipliedBy(currentTempOffset)
                        make.size.equalTo(snp.height)
                    }
                }
            }
        }
    }
}
