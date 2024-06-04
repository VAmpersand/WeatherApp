//
//  TitleCell.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 29.05.2024.
//

import UIKit
import SnapKit

final class WeatherViewHeader: BaseCollectionReusableView {
    // MARK: Properties
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
//    private let descriptionLabel = UILabel() // TODO: - Add descriptionLabel

    // MARK: Lifecycle
    override func setup() {
        super.setup()

        backgroundColor = .waLightBlue
        layer.cornerRadius = 16

        setupIconView()
        setupTitleLabel()
    }

    // MARK: Setup UI
    private func setupIconView() {
        addSubview(iconView)
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .white.withAlphaComponent(0.5)

        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
    }

    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        titleLabel.textColor = .white.withAlphaComponent(0.5)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(8)
            make.verticalEdges.equalToSuperview().inset(12)
        }
    }

    // MARK: Public methods
    func setup(imageSystemName: String, title: String, description: String?) {
        iconView.image = UIImage(systemName: imageSystemName)?
            .applyingSymbolConfiguration(.init(weight: .bold))
        titleLabel.text = title.uppercased()
    }
}
