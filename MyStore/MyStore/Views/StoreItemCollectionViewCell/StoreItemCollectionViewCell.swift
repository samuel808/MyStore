//
//  StoreItemCollectionViewCell.swift
//  MyStore
//
//  Created by Samuelabraham D on 25/07/24.
//

import UIKit

class StoreItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var storeItemaImageView: UIImageView?
    @IBOutlet weak var storeItemNameLabel: UILabel?
    @IBOutlet weak var itemQuantityLabel: UILabel?
    @IBOutlet weak var itemPriceLabel: UILabel?
    @IBOutlet weak var favButton: UIButton?
    @IBOutlet weak var addButton: UIButton?
    @IBOutlet weak var shadowView: UIView?
    
    var didTapProduct: ProductSelectionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addButton?.layer.cornerRadius = 6
        shadowView?.applySketchShadow(color: .lightGray, alpha: 0.3)
    }
    
    @IBAction func favButtonTapped(_ sender: UIButton) {
        didTapProduct?.favoriteButtonTapped(tag: sender.tag)
    }
    
    @IBAction func addToCartTapped(_ sender: UIButton) {
        didTapProduct?.addToCartTapped(tag: sender.tag)
    }
    
}
