//
//  UIViewExtension.swift
//  MyStore
//
//  Created by Samuelabraham D on 26/07/24.
//

import Foundation
import UIKit

extension UIView {
    func applySketchShadow(color: UIColor, alpha: Float = 0.5, xAxis: CGFloat = 0, yAxis: CGFloat = 2, blur: CGFloat = 7, spread: CGFloat = 0, cornerRadius: CGFloat = 8) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = alpha
        self.layer.shadowOffset = CGSize(width: xAxis, height: yAxis)
        self.layer.shadowRadius = blur / 2.0
        if spread == 0 {
            self.layer.shadowPath = nil
        } else {
            let dxt = -spread
            let rect = bounds.insetBy(dx: dxt, dy: dxt)
            self.layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

extension UIColor {
    
    /// Initializes and returns a UIColor object using the specified hexadecimal color string and alpha value.
    /// - Parameters:
    ///   - hex: The hexadecimal color string (e.g., "#RRGGBB" or "RRGGBB").
    ///   - alpha: The alpha value of the color, where 0.0 represents fully transparent and 1.0 represents fully opaque. Default is 1.0.
    public convenience init(hex: String, alpha: CGFloat = 1) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0

        var rgbValue: UInt64 = 0

        scanner.scanHexInt64(&rgbValue)

        let red = (rgbValue & 0xff0000) >> 16
        let green = (rgbValue & 0xff00) >> 8
        let blue = rgbValue & 0xff

        self.init(
            red: CGFloat(red) / 0xff,
            green: CGFloat(green) / 0xff,
            blue: CGFloat(blue) / 0xff, alpha: alpha
        )
    }
}
