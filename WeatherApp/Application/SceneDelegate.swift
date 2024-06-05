//
//  SceneDelegate.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 01.05.2024.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private let weatherProvider: WeatherProvider = WeatherProviderImpl()

    func scene(_ scene: UIScene, 
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        let viewController = CitySelectionViewController()
        viewController.viewModel = CitySelectionViewModel(weatherProvider: weatherProvider)

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = BaseNavigationController(rootViewController: viewController)
        window?.makeKeyAndVisible()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        weatherProvider.sceneWillEnterForeground()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        weatherProvider.sceneDidEnterBackground()
    }
}

