//
//  FavoriteEntity+CoreDataProperties.swift
//  MyStore
//
//  Created by Samuelabraham D on 26/07/24.
//
//

import Foundation
import CoreData


extension FavoriteEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteEntity> {
        return NSFetchRequest<FavoriteEntity>(entityName: "FavoriteEntity")
    }

    @NSManaged public var productId: String?
    @NSManaged public var productName: String?
    @NSManaged public var productIcon: String?
    @NSManaged public var productPrice: Double
    @NSManaged public var isSelected: Bool

}

extension FavoriteEntity : Identifiable {

}
