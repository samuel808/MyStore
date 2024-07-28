//
//  CartEntity+CoreDataProperties.swift
//  MyStore
//
//  Created by Samuelabraham D on 26/07/24.
//
//

import Foundation
import CoreData


extension CartEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartEntity> {
        return NSFetchRequest<CartEntity>(entityName: "CartEntity")
    }

    @NSManaged public var productId: String?
    @NSManaged public var productName: String?
    @NSManaged public var productIcon: String?
    @NSManaged public var quantity: Int64
    @NSManaged public var productPrice: Double
    @NSManaged public var totalPrice: Double
    @NSManaged public var productTotalPrice: Double

}

extension CartEntity : Identifiable {

}
