//
//  UnitSelectionView.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 08.05.2024.
//

import UIKit
import SnapKit

extension UnitSelectionView {
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
}

final class UnitSelectionView: BaseView {
    private let pickerView = UIPickerView()

    private var currentUnit = TempUnit.celsius

    override func setup() {
        super.setup()

        backgroundColor = .white.withAlphaComponent(0.8)

        setupPickerView()
    }

    private func setupPickerView() {
        addSubview(pickerView)
        pickerView.dataSource = self
        pickerView.delegate = self

        pickerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
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
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        TempUnit.allCases[row].unitLabel
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentUnit = TempUnit.allCases[row]
    }
}


