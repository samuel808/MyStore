//
//  CategoryEntity+CoreDataClass.swift
//  MyStore
//
//  Created by Samuelabraham D on 26/07/24.
//
//

import Foundation
import CoreData

@objc(CategoryEntity)
public class CategoryEntity: NSManagedObject {

    func convertToCategoryStruct() -> Categories? {
        var category = Categories()
        category.categoryName = self.categoryName
        category.cateogoryId = Int(self.categoryId ?? "0")
        
        var categoryItem: [CategoryItems]? = []
        let categoryEntity = self.categoryItem?.map({$0})
        self.categoryItem?.forEach({ category in
            categoryItem = category.convertToCategoryItems(entity: categoryEntity)
        })
        category.categoryItems = categoryItem
        
        return category
    }
    
    func convertToCategoryItemList(entity: [CategoryEntity]?) -> [Categories]? {
        guard entity?.count != 0 else { return nil}
        
        var categoryItemList: [Categories]? = []
        entity?.forEach({ category in
            if let list = category.convertToCategoryStruct() {
                categoryItemList?.append(list)
            }
        })
        return categoryItemList
    }
}
