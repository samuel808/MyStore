//
//  FavoriteTableViewCell.swift
//  MyStore
//
//  Created by Samuelabraham D on 26/07/24.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView?
    @IBOutlet weak var itemNameLabel: UILabel?
    @IBOutlet weak var itemPriceLabel: UILabel?
    @IBOutlet weak var productTotalPriceLabel: UILabel?
    @IBOutlet weak var quantityLabel: UILabel?
    @IBOutlet weak var plusButton: UIButton?
    @IBOutlet weak var minusButton: UIButton?
    @IBOutlet weak var shadowView: UIView?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shadowView?.applySketchShadow(color: .lightGray, cornerRadius: 10)
        plusButton?.layer.cornerRadius = 6
        minusButton?.layer.cornerRadius = 6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
