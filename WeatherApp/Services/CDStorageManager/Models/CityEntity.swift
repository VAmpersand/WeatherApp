//
//  CityEntity+CoreDataProperties.swift
//  
//
//  Created by Viktor Prikolota on 19.06.2024.
//
//

import Foundation
import CoreData

@objc(CityEntity)
public class CityEntity: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityEntity> {
        return NSFetchRequest<CityEntity>(entityName: "CityEntity")
    }

    @NSManaged public var id: Int
    @NSManaged public var name: String?
    @NSManaged public var state: String?
    @NSManaged public var country: String?
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double

    var cityData: CityData {
        CityData(id: id,
                 name: name ?? "",
                 state: state ?? "",
                 country: country ?? "",
                 coordinate: Coordinate(lat: lat,
                                        lon: lon))
    }

    func setCityData(_ cityData: CityData) {
        self.id = cityData.id
        self.name = cityData.name
        self.state = cityData.state
        self.country = cityData.country
        self.lat = cityData.coordinate.lat
        self.lon = cityData.coordinate.lon
    }
}
