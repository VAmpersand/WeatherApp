//
//  WebViewController.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 11.05.2024.
//

import UIKit
import SnapKit
import WebKit

class WebViewController: UIViewController {
    private let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupWebView()
    }

    func open(_ url: URL) {
        webView.load(URLRequest(url: url))
    }

    private func setupWebView() {

        view.addSubview(webView)

        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
