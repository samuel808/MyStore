//
//  CategoryItemEntity+CoreDataProperties.swift
//  MyStore
//
//  Created by Samuelabraham D on 26/07/24.
//
//

import Foundation
import CoreData


extension CategoryItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryItemEntity> {
        return NSFetchRequest<CategoryItemEntity>(entityName: "CategoryItemEntity")
    }

    @NSManaged public var categoryItemId: String?
    @NSManaged public var categoryItemName: String?
    @NSManaged public var categoryItemIcon: String?
    @NSManaged public var categoryItemPrice: Double
    @NSManaged public var isSelected: Bool

}

extension CategoryItemEntity : Identifiable {

}
