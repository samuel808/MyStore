//
//  Manager.swift
//  MyStore
//
//  Created by Samuelabraham D on 25/07/24.
//

import Foundation

public class Manager {
    
    static let shared = Manager()
    
    /// reads jsondata from HomeworkHours.json file in bundle
    func getShoppingResponse() -> ShoppingResponse? {
        if let url = Bundle.main.url(forResource: "shopping", withExtension: "json"){
            do {
                let data = try Data(contentsOf: url)
                let shopData = try JSONDecoder().decode(ShoppingResponse.self, from: data)
                return shopData
            }
            catch let error{
                Logger.log(error.localizedDescription)
            }
            return nil
        }
        return nil
    }
    
    func getImageData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
