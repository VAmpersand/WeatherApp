//
//  APIEndpointProvider.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 08.06.2024.
//

import Foundation

final class APIEndpointProvider {
    private let appID: String
    private let baseURL: URL

    init() {
        var format = PropertyListSerialization.PropertyListFormat.xml

        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let data = FileManager.default.contents(atPath: path),
              let config = try? PropertyListSerialization.propertyList(
                from: data,
                options: .mutableContainersAndLeaves,
                format: &format
              ) as? [String: Any] else {
            fatalError("Config.plist not found")
        }

        self.appID = config["appID"] as! String

        let api = config["api"] as! [String: Any]
        let scheme = api["scheme"] as! String
        let host = api["host"] as! String
        let version = api["version"] as! String

        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = version

        baseURL = urlComponents.url!
    }
}
