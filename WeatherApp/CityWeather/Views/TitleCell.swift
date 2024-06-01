//
//  TitleCell.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 29.05.2024.
//

import UIKit
import SnapKit

extension TitleCell {
    struct InputModel {
        let imageSystemName: String
        let title: String
    }
}

final class TitleCell: BaseTableViewCell {
    // MARK: Properties
    private let iconView = UIImageView()
    private let titleLabel = UILabel()

    // MARK: Lifecycle
    override func setup() {
        super.setup()

        setupIconView()
        setupTitleLabel()
    }

    // MARK: Setup UI
    private func setupIconView() {
        contentView.addSubview(iconView)
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .white.withAlphaComponent(0.5)

        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
    }

    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        titleLabel.textColor = .white.withAlphaComponent(0.5)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(8)
            make.verticalEdges.equalToSuperview().inset(12)
        }
    }

    // MARK: Public methods
    func setup(_ inputModel: InputModel) {
        iconView.image = UIImage(systemName: inputModel.imageSystemName)?
            .applyingSymbolConfiguration(.init(weight: .bold))
        titleLabel.text = inputModel.title.uppercased()
    }
}
