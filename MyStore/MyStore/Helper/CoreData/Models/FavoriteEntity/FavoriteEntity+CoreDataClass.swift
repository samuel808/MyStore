//
//  FavoriteEntity+CoreDataClass.swift
//  MyStore
//
//  Created by Samuelabraham D on 26/07/24.
//
//

import Foundation
import CoreData

@objc(FavoriteEntity)
public class FavoriteEntity: NSManagedObject {

    func convertToFavoriteStruct() -> CategoryItems? {
        var categoryItem = CategoryItems()
        categoryItem.itemIcons = self.productIcon
        categoryItem.itemName = self.productName
        categoryItem.itemId = Int(self.productId ?? "0")
        categoryItem.itemPrice = self.productPrice
        categoryItem.isSelected = self.isSelected
        
        return categoryItem
    }
    
    func convertToFavoriteList(entity: [FavoriteEntity]?) -> [CategoryItems]? {
        guard entity?.count != 0 else {
            return nil
        }
        var categoryItem: [CategoryItems] = []
        entity?.forEach({ favoriteList in
            if let list = favoriteList.convertToFavoriteStruct() {
                categoryItem.append(list)
            }
        })
        return categoryItem
    }
}
