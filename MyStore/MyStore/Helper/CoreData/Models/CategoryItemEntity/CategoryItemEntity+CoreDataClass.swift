//
//  CategoryItemEntity+CoreDataClass.swift
//  MyStore
//
//  Created by Samuelabraham D on 26/07/24.
//
//

import Foundation
import CoreData

@objc(CategoryItemEntity)
public class CategoryItemEntity: NSManagedObject {

    func convertEntityToStruct() -> CategoryItems? {
        var categoryItem = CategoryItems()
        categoryItem.itemIcons = self.categoryItemIcon
        categoryItem.itemName = self.categoryItemName
        categoryItem.itemId = Int(self.categoryItemId ?? "0")
        categoryItem.itemPrice = self.categoryItemPrice
        categoryItem.isSelected = self.isSelected
        
        return categoryItem
    }
    
    func convertToCategoryItems(entity: [CategoryItemEntity]?) -> [CategoryItems]? {
        guard entity?.count != 0 else {
            return nil
        }
        var categoryItem:[CategoryItems] = []
        entity?.forEach({ category in
            if let item = category.convertEntityToStruct() {
                categoryItem.append(item)
            }
        })
        return categoryItem
    }
}
