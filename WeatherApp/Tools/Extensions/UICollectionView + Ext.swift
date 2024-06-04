//
//  UICollectionView + Ext.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 01.06.2024.
//

import UIKit

extension UICollectionView {
    func registerCell(_ type: UICollectionViewCell.Type) {
        let identifier = String(describing: type)
        register(type, forCellWithReuseIdentifier: identifier)
    }
    
    func registerView(_ type: UICollectionReusableView.Type, ofKind kind: String) {
        let identifier = String(describing: type)
        register(type, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }

    func dequeueCell<Cell: UICollectionViewCell>(_ type: Cell.Type, for indexPath: IndexPath) -> Cell {
        let identifier = String(describing: type)

        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? Cell else {
            fatalError("❌ Couldn't dequeue cell with identifier: \(identifier) for indexPath: \(indexPath)")
        }

        return cell
    }

    func dequeueView<View: UICollectionReusableView>(
        _ type: View.Type,
        ofKind kind: String,
        for indexPath: IndexPath
    ) -> View {
        let identifier = String(describing: type)

        guard let view = dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: identifier,
            for: indexPath
        ) as? View else {
            fatalError("❌ Couldn't dequeue cell with identifier: \(identifier) for indexPath: \(indexPath)")
        }

        return view
    }
}
