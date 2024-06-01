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
            image: UIImage(systemName: "xmark.circle.fill")?
                .applyingSymbolConfiguration(.init(hierarchicalColor: .white))?
                .applyingSymbolConfiguration(.init(font: .systemFont(ofSize: 20))),
            style: .plain,
            target: self,
            action: #selector(closeAction)
        )
    }

    func presentWebView(with url: URL?, title: String?) {
        let webViewController = WebViewController()
        if let url { webViewController.open(url) }
        webViewController.title = title
        let navigationController = BaseNavigationController(rootViewController: webViewController)
        present(navigationController, animated: true)
    }

    @IBAction private func closeAction() {
        dismiss(animated: true)
    }
}
