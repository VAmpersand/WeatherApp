//
//  InfoFooter.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 01.06.2024.
//

import UIKit
import SnapKit

final class InfoFooter: BaseCollectionReusableView {
    // MARK: Properties
    private let infoTextView = UITextView()

    var linkAction: ((URL) -> Void)?

    // MARK: Lifecycle
    override func setup() {
        super.setup()

        setupInfoLabel()
    }

    // MARK: Setup UI
    private func setupInfoLabel() {
        addSubview(infoTextView)
        infoTextView.font = .systemFont(ofSize: 13, weight: .medium)
        infoTextView.isEditable = false
        infoTextView.isScrollEnabled = false
        infoTextView.textContainerInset = .zero
        infoTextView.linkTextAttributes = [.foregroundColor: UIColor.gray,
                                           .underlineStyle: NSUnderlineStyle.single.rawValue]
        infoTextView.backgroundColor = .clear
        infoTextView.delegate = self

        infoTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(8)
        }
    }

    // MARK: Public methods
    func setup(_ infoAttributedString: NSAttributedString?) {
        infoTextView.attributedText = infoAttributedString
    }
}

extension InfoFooter: UITextViewDelegate {
    func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange,
        interaction: UITextItemInteraction
    ) -> Bool {
        linkAction?(URL)
        return false
    }
}
