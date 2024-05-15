//
//  WebViewController.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 11.05.2024.
//

import UIKit
import SnapKit
import WebKit

class WebViewController: BaseViewController {
    private let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "darkGrey")

        setupCloseButton()
        setupWebView()
    }

    func open(_ url: URL) {
        webView.load(URLRequest(url: url))
    }

    private func setupWebView() {
        view.addSubview(webView)
        webView.backgroundColor = .clear
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.horizontalEdges.equalToSuperview()
        }
    }
}
