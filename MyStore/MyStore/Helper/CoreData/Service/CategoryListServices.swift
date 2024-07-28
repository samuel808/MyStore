//
//  CategoryListServices.swift
//  MyStore
//
//  Created by Samuelabraham D on 27/07/24.
//

import Foundation
import CoreData

class CategoryListServices: CoreDataServices {
    
    func fetchCategoryList() -> [CategoryEntity]? {
        let fetchRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        
        do {
            let result = try self.fetchManagedObject(request: fetchRequest)
            
            guard let categoryEntity = result else {
                return nil
            }
            return categoryEntity
        } catch let error as NSError {
            Logger.log("CategoryEntity = \(error.localizedDescription)")
        }
        return nil
    }
    
    func saveCategoryList(categoryList: [Categories]?) {
        deleteOneTableRecodes(entity: "CategoryEntity") { status, entity in
            if fetchCategoryList() == nil || fetchCategoryList()?.isEmpty == true{
                let context = self.getContext()
                if let tCategoryList = categoryList {
                    tCategoryList.forEach { category in
                        let tCategory = CategoryEntity(context:context)
                        tCategory.categoryId = String(category.cateogoryId ?? 0)
                        tCategory.categoryName = category.categoryName
                        
                        if let item = category.categoryItems {
                            item.forEach { categoryItem in
                                let categoryItemEntity = CategoryItemEntity(context: self.getContext())
                                categoryItemEntity.categoryItemIcon = categoryItem.itemIcons
                                categoryItemEntity.categoryItemId = String(categoryItem.itemId ?? 0)
                                categoryItemEntity.categoryItemName = categoryItem.itemName
                                categoryItemEntity.categoryItemPrice = categoryItem.itemPrice ?? 0.0
                                categoryItemEntity.isSelected = categoryItem.isSelected ?? false
                                tCategory.addToCategoryItem(categoryItemEntity)
                            }
                        }
                    }
                    _ = context.saveIfChanged()
                }
            }
        }
    }
    
    func getCategoryFetchById(id: String) -> CategoryEntity?{
        let fetchRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        let fetchById = NSPredicate(format: "categoryId==%@", id)
        
        do {
            let result = try self.fetchManagedObject(request: fetchRequest, predicate: fetchById)
            guard let cartInfo = result?.first else {
                return nil
            }
            return cartInfo
        } catch let error as NSError {
            Logger.log("CategoryEntity = \(error.localizedDescription)")
        }
        
        return nil
    }
    
    func updateCategoryDetail(id: String, itemId: String, handler: (() -> Void)? = nil ) {
        guard let categoryInfo = getCategoryFetchById(id: id) else { return }
        guard let categoryItems = categoryInfo.categoryItem else { return }
        
        for index in categoryItems.indices {
            if categoryItems[index].categoryItemId == itemId {
                categoryItems[index].isSelected = false
            }
        }
        
        categoryInfo.categoryItem = categoryItems
        _ = categoryInfo.managedObjectContext?.saveIfChanged()
        handler?()
    }
}
