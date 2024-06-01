//
//  DayWeatherCell.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 04.05.2024.
//

import UIKit
import SnapKit

extension DayWeatherCell {
    struct InputModel {
        let title: String
        let imageSystemName: String
        let minTemp: Double
        let maxTemp: Double
        let minDayTemp: Double
        let maxDayTemp: Double
        let currentTemt: Double?
    }
}

final class DayWeatherCell: BaseTableViewCell {
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

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
    }

    // MARK: Setup UI
    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .white

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview().inset(12)
            make.width.equalTo(60)
        }
    }

    private func setupIconView() {
        contentView.addSubview(iconView)
        iconView.contentMode = .scaleAspectFit

        iconView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
    }

    private func setupMinTempLable() {
        contentView.addSubview(minTempLabel)
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
        contentView.addSubview(tempLimitsView)

        tempLimitsView.snp.makeConstraints { make in
            make.leading.equalTo(minTempLabel.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
    }

    private func setupMaxTempLabel() {
        contentView.addSubview(maxTempLabel)
        maxTempLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        maxTempLabel.textAlignment = .center
        maxTempLabel.textColor = .white

        maxTempLabel.snp.makeConstraints { make in
            make.leading.equalTo(tempLimitsView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(30)
        }
    }

    // MARK: Public methods
    func setup(_ inputModel: InputModel) {
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
        func setup(_ model: InputModel) {
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
