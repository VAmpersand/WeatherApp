//
//  UnitSelectionView.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 08.05.2024.
//

import UIKit
import SnapKit

protocol UnitSelectionViewDelegate: AnyObject {
    func didSelectUnit(_ unit: TempUnit)
    func showUnitInfo()
}

enum TempUnit: Int, CaseIterable {
    case celsius
    case kelvin
    case fahrenheit

    var unitLabel: String {
        switch self {
        case .celsius: return "ºС"
        case .fahrenheit: return "ºF"
        case .kelvin: return "ºK"
        }
    }
}

final class UnitSelectionView: BaseView {
    // MARK: Properties
    private let pickerView = UIPickerView()
    private let infoButton = UIButton()

    weak var delegate: UnitSelectionViewDelegate?

    // MARK: Lifecycle
    override func setup() {
        super.setup()

        backgroundColor = .waDarkGray
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 50
        layer.shadowOpacity = 1

        setupPickerView()
        setupInfoButton()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if pickerView.subviews.indices.contains(1) {
            pickerView.subviews[1].backgroundColor = .white.withAlphaComponent(0.1)
        }
    }

    // MARK: Setup UI
    private func setupPickerView() {
        addSubview(pickerView)
        pickerView.tintColor = .white
        pickerView.dataSource = self
        pickerView.delegate = self

        pickerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(100)
            make.width.equalTo(150)
        }
    }

    private func setupInfoButton() {
        addSubview(infoButton)
        infoButton.setImage(
            UIImage(systemName: "questionmark.circle")?.applyingSymbolConfiguration(.init(font: .systemFont(ofSize: 22))),
            for: .normal
        )
        infoButton.tintColor = .white
        infoButton.addAction(UIAction { [weak self] _ in
            self?.delegate?.showUnitInfo()
        }, for: .touchUpInside)

        infoButton.snp.makeConstraints { make in
            make.top.equalTo(pickerView.snp.bottom).offset(16)
            make.bottom.trailing.equalToSuperview().inset(16)
            make.size.equalTo(25)
        }
    }

    // MARK: Public methods
}

// MARK: - UIPickerViewDataSource
extension UnitSelectionView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        TempUnit.allCases.count
    }
}

// MARK: - UIPickerViewDelegate
extension UnitSelectionView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, 
                    attributedTitleForRow row: Int,
                    forComponent component: Int) -> NSAttributedString? {
        NSAttributedString(string: TempUnit.allCases[row].unitLabel, attributes: [.foregroundColor: UIColor.white])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.didSelectUnit(TempUnit.allCases[row])
    }
}

