//
//  StoreModel.swift
//  MyStore
//
//  Created by Samuelabraham D on 25/07/24.
//

import Foundation

struct ShoppingResponse: Codable {
    var status: Bool?
    var message: String?
    var categories: [Categories]?
    
    enum CodingKeys: String, CodingKey {
        case status, message, categories
    }
}

struct Categories: Codable {
    var cateogoryId: Int?
    var categoryName: String?
    var categoryItems: [CategoryItems]?
    var isExpand: Bool? = true
    
    enum CodingKeys: String, CodingKey {
        case cateogoryId = "id", categoryName = "name", categoryItems = "items"
    }
}

struct CategoryItems: Codable {
    var itemId: Int?
    var itemName, itemIcons: String?
    var itemPrice: Double?
    var isSelected: Bool?
    var quantity: Int?
    var totalPrice: Double?
    
    enum CodingKeys: String, CodingKey {
        case itemId = "id", itemName = "name", itemIcons = "icon", itemPrice = "price"
    }
}
