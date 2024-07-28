//
//  FavoriteListServices.swift
//  MyStore
//
//  Created by Samuelabraham D on 27/07/24.
//

import Foundation
import CoreData

class FavoriteListServices: CoreDataServices {
    
    func fetchFavoriteList() -> [FavoriteEntity]? {
        let fetchRequest: NSFetchRequest<FavoriteEntity> = FavoriteEntity.fetchRequest()
        
        do {
            let result = try self.fetchManagedObject(request: fetchRequest)
            
            guard let favoriteEntity = result else {
                return nil
            }
            return favoriteEntity
        } catch let error as NSError {
            Logger.log("FavoriteEntity = \(error.localizedDescription)")
        }
        return nil
    }
    
    func saveFavoriteList(favoriteList: [CategoryItems]?) {
        deleteOneTableRecodes(entity: "FavoriteEntity") { status, entity in
            if fetchFavoriteList() == nil || fetchFavoriteList()?.isEmpty == true{
                let context = self.getContext()
                if let tFavList = favoriteList {
                    tFavList.forEach { favorite in
                        let tFavorite = FavoriteEntity(context:context)
                        tFavorite.productIcon = favorite.itemIcons
                        tFavorite.productId = String(favorite.itemId ?? 0)
                        tFavorite.productName = favorite.itemName
                        tFavorite.productPrice = favorite.itemPrice ?? 0.0
                        tFavorite.isSelected = favorite.isSelected ?? false
                    }
                }
                _ = context.saveIfChanged()
            }
        }
    }
    
    private func getProductFetchById(id: String) -> FavoriteEntity?{
        let fetchRequest: NSFetchRequest<FavoriteEntity> = FavoriteEntity.fetchRequest()
        let fetchById = NSPredicate(format: "productId==%@", id)
        
        do {
            let result = try self.fetchManagedObject(request: fetchRequest, predicate: fetchById)
            guard let cartInfo = result?.first else {
                return nil
            }
            return cartInfo
        } catch let error as NSError {
            Logger.log("CartEntity = \(error.localizedDescription)")
        }
        
        return nil
    }
    
    func deleteFavoriteItem(id: String, handler: (() -> Void)? = nil) {
        let context = getContext()
        
        context.perform {
            if let cart = self.getProductFetchById(id: id) {
                context.delete(cart)
                if let error = context.saveIfChanged() {
                    print("Failed to delete and save favorite item: \(error.localizedDescription)")
                } else {
                    handler?()
                }
            } else {
                print("No records")
            }
        }
    }
}
