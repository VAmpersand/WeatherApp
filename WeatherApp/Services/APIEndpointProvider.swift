//
//  APIEndpointProvider.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 08.06.2024.
//

import Foundation

enum Endpount {
    case weather(id: Int)
    case forecast(id: Int)
    case coordWeather(lat: Double, lon: Double)
    case coordForecast(lat: Double, lon: Double)
    case group(ids: [Int])

    var pathComponent: String {
        switch self {
        case .weather, .coordWeather: return "weather"
        case .forecast, .coordForecast: return "forecast"
        case .group: return "group"
        }
    }
}

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

        var urlComponents = URLComponents()
        urlComponents.scheme = api["scheme"] as! String
        urlComponents.host = api["host"] as! String
        urlComponents.path = api["version"] as! String

        baseURL = urlComponents.url!
    }

    func getURL(for endpoint: Endpount) -> URL{
        var url = baseURL
        url.append(path: endpoint.pathComponent)

        switch endpoint {
        case .weather(let id), .forecast(let id):
            url.append(queryItems: [
                URLQueryItem(name: "id", value: String(id))
            ])
        case .coordWeather(let lat, let lon), .coordForecast(let lat, let lon):
            url.append(queryItems: [
                URLQueryItem(name: "lat", value: String(lat)),
                URLQueryItem(name: "lon", value: String(lon))
            ])
        case .group(let ids):
            url.append(queryItems: [
                URLQueryItem(name: "id",value: ids.map { String($0) }.joined(separator: ","))
            ])
        }

        url.append(queryItems: [
            URLQueryItem(name: "appid", value: appID)
        ])

        return url
    }
}
