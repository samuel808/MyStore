//
//  CartListServices.swift
//  MyStore
//
//  Created by Samuelabraham D on 27/07/24.
//

import Foundation
import CoreData

class CartListServices: CoreDataServices {
    
    func fetchCartList() -> [CartEntity]? {
        let fetchRequest: NSFetchRequest<CartEntity> = CartEntity.fetchRequest()
        
        do {
            let result = try self.fetchManagedObject(request: fetchRequest)
            
            guard let cartEntity = result else {
                return nil
            }
            return cartEntity
        } catch let error as NSError {
            Logger.log("CartEntity = \(error.localizedDescription)")
        }
        return nil
    }
    
    func saveCartList(cartList: [CategoryItems]?) {
        deleteOneTableRecodes(entity: "CartEntity") { status, entity in
            if fetchCartList() == nil || fetchCartList()?.isEmpty == true{
                let context = self.getContext()
                if let tCartList = cartList {
                    tCartList.forEach { cart in
                        let tCart = CartEntity(context:context)
                        tCart.productIcon = cart.itemIcons
                        tCart.productId = String(cart.itemId ?? 0)
                        tCart.productName = cart.itemName
                        tCart.productPrice = cart.itemPrice ?? 0.0
                        tCart.quantity = Int64(cart.quantity ?? 1)
                        tCart.totalPrice = ((cart.itemPrice ?? 0.0) * Double(cart.quantity ?? 0))
                    }
                }
                _ = context.saveIfChanged()
            }
        }
    }
    
    func getProductFetchById(id: String) -> CartEntity?{
        let fetchRequest: NSFetchRequest<CartEntity> = CartEntity.fetchRequest()
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
    
    func updateCartQuantity(id: String, quantity: Int){
        let cartInfo = getProductFetchById(id: id)
        cartInfo?.quantity = Int64(quantity)
        cartInfo?.totalPrice = (Double(cartInfo?.quantity ?? 1) * (cartInfo?.productPrice ?? 0.0))
        _ = cartInfo?.managedObjectContext?.saveIfChanged()
    }
    
    func deleteCartItem(id: String, handler: (() -> Void)? = nil) {
        let context = getContext()
        
        context.perform {
            if let cart = self.getProductFetchById(id: id) {
                context.delete(cart)
                if let error = context.saveIfChanged() {
                    print("Failed to delete and save cart item: \(error.localizedDescription)")
                } else {
                    handler?()
                }
            } else {
                print("No records")
            }
        }
    }
}
