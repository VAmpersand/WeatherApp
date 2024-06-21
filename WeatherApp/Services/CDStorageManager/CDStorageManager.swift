//
//  CDStorageManager.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 19.06.2024.
//

import Foundation
import CoreData

final class CDStorageManager {
    private let queue = DispatchQueue.init(label: "coreDataSyncQueue", qos: .background)

    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores { _, error in
            if let error { fatalError("Loading contaner failed") }
        }
        return container
    }()

    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    init() {
        urlDocumentDirectory()
    }

    private func urlDocumentDirectory() {
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            print(url.absoluteString)
        }
    }
}


// MARK: - CRUD
extension CDStorageManager {
    // MARK: Create
    func storeCityData(_ data: [CityData], completion: @escaping (Bool) -> Void) {
        queue.sync { [context] in
            data.forEach { data in
                let city = CityEntity(context: context)
                city.setCityData(data)
            }

            do {
                try context.save()
                DispatchQueue.main.async {
                    completion(true)
                }
            } catch let error {
                print(error)
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }

    // MARK: Reed
    func fetchCityData(completion: @escaping ([CityData]?) -> Void) {
        queue.sync { [context] in
            let fetchRequest = CityEntity.fetchRequest()
            let ferchResult = try? context.fetch(fetchRequest)
            let data = ferchResult?.map(\.cityData)

            DispatchQueue.main.async {
                completion(data)
            }
        }
    }

    func fetchCityData(with id: Int, completion: @escaping (CityData?) -> Void) {
        queue.sync { [context] in
            let fetchRequest = CityEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", String(id))
            let ferchResult = try? context.fetch(fetchRequest)
            let city = ferchResult?.first

            DispatchQueue.main.async {
                if let city {
                    completion(city.cityData)
                } else {
                    completion(nil)
                }
            }
        }
    }

    func fetchCityData(with searchQuery: String?, completion: @escaping ([CityData]) -> Void) {
        let fetchRequest = CityEntity.fetchRequest()
        let countryDescriptor = NSSortDescriptor(key: "country", ascending: true)
        let stateDescriptor = NSSortDescriptor(key: "state", ascending: true)
        let nameDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [countryDescriptor, stateDescriptor, nameDescriptor]
        fetchRequest.fetchBatchSize = 20

        if let searchQuery {
            fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchQuery.lowercased())
        }

        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { request in
            if let result = request.finalResult {
                let data = result.map(\.cityData)

                DispatchQueue.main.async {
                    completion(data)
                }
            }
        }

        do {
            try context.execute(asyncFetchRequest)
        } catch {
            DispatchQueue.main.async {
                completion([])
            }
        }
    }

    // MARK: Update
    func updateCityData(with id: Int, newData: CityData, completion: @escaping (Bool) -> Void) {
        queue.sync { [context] in
            let fetchRequest = CityEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", String(id))
            let ferchResult = try? context.fetch(fetchRequest)
            let city = ferchResult?.first

            city?.setCityData(newData)

            do {
                try context.save()
                DispatchQueue.main.async {
                    completion(true)
                }
            } catch let error {
                print(error)
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }

    // MARK: Delete
    func removeAllCityData(completion: @escaping (Bool) -> Void) {
        queue.sync { [context] in
            let fetchRequest = CityEntity.fetchRequest()
            let ferchResult = try? context.fetch(fetchRequest)

            ferchResult?.forEach { city in
                context.delete(city)
            }

            do {
                try context.save()
                DispatchQueue.main.async {
                    completion(true)
                }
            } catch let error {
                print(error)
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }

    func removeCityData(for id: Int, completion: @escaping (Bool) -> Void) {
        queue.sync { [context] in
            let fetchRequest = CityEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", String(id))
            let ferchResult = try? context.fetch(fetchRequest)

            ferchResult?.forEach { city in
                context.delete(city)
            }

            do {
                try context.save()
                DispatchQueue.main.async {
                    completion(true)
                }
            } catch let error {
                print(error)
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
}
