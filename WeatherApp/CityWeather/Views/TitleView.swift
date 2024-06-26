//
//  TitleView.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 01.05.2024.
//

import UIKit
import SnapKit

final class TitleView: BaseView {
    // MARK: Properties
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let tempLabel = UILabel()
    private let descriptionLable = UILabel()
    private let tempLimitsLabel = UILabel()

    private let verticalOffset: CGFloat = 50

    // MARK: Lifecycle
    override func setup() {
        super.setup()

        setupStackView()
        setupTitleLabel()
        setupSubitleLabel()
        setupTempLabel()
        setupDescriptionLable()
        setupTempLimitsLabel()
    }
    
    // MARK: Setup UI
    private func setupStackView() {
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fillProportionally
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(verticalOffset)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(verticalOffset)
            make.height.equalTo(300)
        }
    }
    
    private func setupTitleLabel() {
        stackView.addArrangedSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white

        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
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
    }
    
    private func setupTempLimitsLabel() {
        stackView.addArrangedSubview(tempLimitsLabel)
        tempLimitsLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        tempLimitsLabel.textAlignment = .center
        tempLimitsLabel.textColor = .white
    }

    // MARK: Public methods
    func setup(_ model: TitleViewData) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        subtitleLabel.isHidden = model.subtitle == nil
        tempLabel.text = model.currentTemp?.formatedTemp()
        descriptionLable.text = model.description

        if let maxTemp = model.maxTemp, let minTemp = model.minTemp {
            tempLimitsLabel.text = "Max: \(maxTemp.formatedTemp()), min: \(minTemp.formatedTemp())"
        }
    }

    func update(with offset: CGFloat) {

//        UIView.animate(withDuration: 0.15) { [self] in
//            stackView.snp.updateConstraints { make in
//                make.top.equalToSuperview().inset(verticalOffset)
//                make.bottom.equalToSuperview().inset(verticalOffset)
//            }

        let insetValue = verticalOffset - offset / 2

        stackView.snp.updateConstraints { make in
            make.top.equalToSuperview().inset(insetValue > 0 ? insetValue : 0)
            make.height.equalTo(300 - offset / 2)
            make.bottom.equalToSuperview().inset(insetValue > 0 ? insetValue : 0)
        }

//        print("_123", offset)
        switch offset {
        case 0..<40:
//            let animatedOffset: CGFloat = 40
            let insetValue = verticalOffset - offset
//            print("_123", offset, insetValue)

//            DispatchQueue.main.async {
//
//                self.stackView.snp.updateConstraints { make in
//                    make.top.equalToSuperview().inset(insetValue)
////                    make.horizontalEdges.equalToSuperview().inset(20)
//                    make.bottom.equalToSuperview().inset(insetValue)
//                }
//            }
            //            layoutIfNeeded()


            //                self.tempLimitsLabel.isHidden = true
        case 60..<100: break
            //                self.tempLabel.isHidden = true
        default: break
        }
        //        }
    }
}
