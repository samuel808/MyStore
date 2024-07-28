//
//  CartTableViewCell.swift
//  MyStore
//
//  Created by Samuelabraham D on 26/07/24.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView?
    @IBOutlet weak var productNameLabel: UILabel?
    @IBOutlet weak var productPriceLabel: UILabel?
    @IBOutlet weak var favButton: UIButton?
    @IBOutlet weak var addButton: UIButton?
    @IBOutlet weak var borderView: UIView?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        borderView?.applySketchShadow(color: .lightGray, cornerRadius: 10)
        addButton?.layer.cornerRadius = 6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
