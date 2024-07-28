//
//  CartEntity+CoreDataClass.swift
//  MyStore
//
//  Created by Samuelabraham D on 26/07/24.
//
//

import Foundation
import CoreData

@objc(CartEntity)
public class CartEntity: NSManagedObject {

    func convertToCartStruct() -> CategoryItems? {
        var categoryItem = CategoryItems()
        categoryItem.itemIcons = self.productIcon
        categoryItem.itemName = self.productName
        categoryItem.itemId = Int(self.productId ?? "0")
        categoryItem.itemPrice = self.productPrice
        categoryItem.quantity = Int(self.quantity)
        categoryItem.totalPrice = self.totalPrice
        
        return categoryItem
    }
    
    func convertToCartList(entity: [CartEntity]?) -> [CategoryItems]? {
        guard entity?.count != 0 else {
            return nil
        }
        var categoryItem: [CategoryItems] = []
        entity?.forEach({ favoriteList in
            if let list = favoriteList.convertToCartStruct() {
                categoryItem.append(list)
            }
        })
        return categoryItem
    }
}
