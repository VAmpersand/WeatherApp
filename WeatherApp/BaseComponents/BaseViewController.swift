//
//  BaseViewController.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 04.05.2024.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    func setup() {}

    func setupCloseButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark.circle.fill")?.applyingSymbolConfiguration(.init(hierarchicalColor: .white)),
            style: .plain,
            target: self,
            action: #selector(closeAction)
        )
    }

    @IBAction private func closeAction() {
        dismiss(animated: true)
    }
}
