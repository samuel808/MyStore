//
//  CategoryEntity+CoreDataProperties.swift
//  MyStore
//
//  Created by Samuelabraham D on 26/07/24.
//
//

import Foundation
import CoreData


extension CategoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryEntity> {
        return NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
    }

    @NSManaged public var categoryId: String?
    @NSManaged public var categoryName: String?
    @NSManaged public var categoryItem: Set<CategoryItemEntity>?

}

extension CategoryEntity : Identifiable {
    
    @objc(addCategoryItemObject:)
    @NSManaged public func addToCategoryItem(_ value: CategoryItemEntity)
    
    @objc(removeCategoryItemObject:)
    @NSManaged public func removeFromCategoryItem(_ value: CategoryItemEntity)
    
    @objc(addCategoryItems:)
    @NSManaged public func addToCategoryItem(_ values: NSSet)
    
    @objc(removeCategoryItems:)
    @NSManaged public func removeFromCategoryItem(_ values: NSSet)
}
