//
//  BaseNavigationController.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 14.05.2024.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        navigationBar.isTranslucent = true
        navigationBar.barStyle = .black
        navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBar.tintColor = .white
    }
}
