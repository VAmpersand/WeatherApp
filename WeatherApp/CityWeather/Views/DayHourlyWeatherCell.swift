//
//  DayHourlyWeatherCell.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 01.05.2024.
//

import UIKit
import SnapKit

extension DayHourlyWeatherCell {
    struct InputModel {
        let hour: String
        let imageSystemName: String
        let temp: Int
    }
}

final class DayHourlyWeatherCell: BaseTableViewCell {
    // MARK: Properties
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()

    // MARK: Lifecycle
    override func setup() {
        super.setup()

        setupScrollView()
        setupStackView()
    }

    // MARK: Setup UI
    private func setupScrollView() {
        contentView.addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        scrollView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(100)
        }
    }

    private func setupStackView() {
        scrollView.addSubview(stackView)
        stackView.spacing = 15
        stackView.distribution = .fillEqually

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: Public methods
    func setup(_ models: [InputModel]) {
        stackView.subviews.forEach { $0.removeFromSuperview() }
        
        models.enumerated().forEach { index, model in
            let view = HourWeatherView()
            view.setup(model)
            stackView.addArrangedSubview(view)
            if index == 0 {
                stackView.setCustomSpacing(35, after: view)
            }
        }
    }
}

// MARK: - HourWeatherView
extension DayHourlyWeatherCell {
    final class HourWeatherView: UIView {
        // MARK: Properties
        private let stackView = UIStackView()
        private let hourLabel = UILabel()
        private let iconView = UIImageView()
        private let tempLabel = UILabel()

        // MARK: Lifecycle
        override init(frame: CGRect) {
            super.init(frame: frame)

            setupStackView()
            setupHourLabel()
            setupIconView()
            setupTempLabel()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // MARK: Setup UI
        private func setupStackView() {
            addSubview(stackView)
            stackView.axis = .vertical
            stackView.spacing = 16
            stackView.distribution = .fillEqually

            stackView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.width.equalTo(40)
            }
        }

        private func setupHourLabel() {
            stackView.addArrangedSubview(hourLabel)
            hourLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            hourLabel.textAlignment = .center
            hourLabel.textColor = .white
        }

        private func setupIconView() {
            stackView.addArrangedSubview(iconView)
            iconView.contentMode = .scaleAspectFit
        }

        private func setupTempLabel() {
            stackView.addArrangedSubview(tempLabel)
            tempLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            tempLabel.textAlignment = .center
            tempLabel.textColor = .white
        }

        // MARK: Public methods
        func setup(_ model: InputModel) {
            hourLabel.text = model.hour
            iconView.image = UIImage(systemName: model.imageSystemName)?.withRenderingMode(.alwaysOriginal)
            tempLabel.text = "\(model.temp)º"
        }
    }
}
