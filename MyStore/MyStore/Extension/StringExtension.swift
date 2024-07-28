//
//  UIImageViewExtension.swift
//  MyStore
//
//  Created by Samuelabraham D on 26/07/24.
//

import Foundation
import UIKit

extension String {
    
    func getImageFromURL(completion: @escaping (UIImage?) -> Void) {
        if let url = URL(string: self) {
            Manager.shared.getImageData(from: url) { data, response, error in
                guard let data = data, error == nil else {
                    completion(nil)
                    return
                }
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    completion(image)
                }
            }
        }
    }
}
