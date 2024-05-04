//
//  DayTempLimitsView.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 01.05.2024.
//

import UIKit
import SnapKit

extension DayTempLimitsView {
    struct InputModel {
        let minWeekTemp: Double
        let maxWeekTemp: Double
        let minDayTemp: Double
        let maxDayTemp: Double
        let currentTemt: Double?
    }
}

final class DayTempLimitsView: BaseView {
    private let tempLimitsView = UIView()
    private let currentTempView = UIView()

    override func setup() {
        super.setup()

        backgroundColor = UIColor(named: "darkBlue")?.withAlphaComponent(0.5)
        layer.cornerRadius = 3

        snp.makeConstraints { make in
            make.height.equalTo(6)
        }

        setupTempLimitsView()
        setupCurrentTempView()
    }

    func setup(_ model: InputModel) {
        let weekTempDiff = model.maxWeekTemp - model.minWeekTemp
        let minOffset = abs(model.minWeekTemp - model.minDayTemp) / weekTempDiff
        let maxOffset = abs(model.maxWeekTemp - model.maxDayTemp) / weekTempDiff

        tempLimitsView.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().multipliedBy(1 - maxOffset)
            make.width.equalToSuperview().multipliedBy(1 - minOffset - maxOffset)
            make.height.equalToSuperview()
        }

        if let currentTemt = model.currentTemt {
            let currentTempOffset = abs(model.minWeekTemp - currentTemt) / weekTempDiff

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

    private func setupTempLimitsView() {
        addSubview(tempLimitsView)

        tempLimitsView.backgroundColor = UIColor(named: "darkYellow")
        tempLimitsView.layer.borderColor = UIColor(named: "darkBlue")?.withAlphaComponent(0.7).cgColor
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
        currentTempView.layer.borderColor = UIColor(named: "darkBlue")?.withAlphaComponent(0.7).cgColor
        currentTempView.layer.borderWidth = 1
        currentTempView.layer.cornerRadius = 3

        currentTempView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.size.equalTo(snp.height)
        }
    }
}
