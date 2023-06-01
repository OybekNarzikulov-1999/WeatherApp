//
//  CachedResponse+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Oybek Narzikulov on 01/06/23.
//
//

import Foundation
import CoreData


extension CachedResponse {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedResponse> {
        return NSFetchRequest<CachedResponse>(entityName: "CachedResponse")
    }

    @NSManaged public var url: String?
    @NSManaged public var responseData: Data?

}

extension CachedResponse : Identifiable {

}
