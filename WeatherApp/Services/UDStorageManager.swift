//
//  UDStorageManager.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 15.06.2024.
//

import Foundation

enum StorageKey: String {
    case weatherUploadDate
}

final class UDStorageManager {
    private let userDefaults = UserDefaults.standard

    func set<T: Codable>(object: T, fotKey key: StorageKey) {
        guard let data = try? JSONEncoder().encode(object) else { return }

        userDefaults.set(data, forKey: key.rawValue)
    }

    func object<T: Codable>(forKey key: StorageKey) -> T? {
        guard let data = userDefaults.object(forKey: key.rawValue) as? Data else { return nil }

        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    func delete(forKey key: StorageKey) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
}
