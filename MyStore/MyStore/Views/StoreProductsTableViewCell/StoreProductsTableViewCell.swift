//
//  StoreProductsTableViewCell.swift
//  MyStore
//
//  Created by Samuelabraham D on 25/07/24.
//

import UIKit

class StoreProductsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var storeItemCollectionView: UICollectionView?
    @IBOutlet weak var storeItemCollectionVIewHeight: NSLayoutConstraint?
    
    var categoryItems: [CategoryItems]? {
        didSet {
            storeItemCollectionView?.reloadData()
        }
    }
    var addToCart: ((CategoryItems?) -> Void)? = nil
    var addToFavorite: ((CategoryItems?) -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let collectionView = storeItemCollectionView {
            configCollectionView(collectionView: collectionView)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func configCollectionView(collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "StoreItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StoreItemCollectionViewCell")
    }
}

extension StoreProductsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreItemCollectionViewCell", for: indexPath) as? StoreItemCollectionViewCell else { return StoreItemCollectionViewCell() }
        categoryItems?[indexPath.row].itemIcons?.getImageFromURL(completion: { image in
            if let tImage = image {
                cell.storeItemaImageView?.image = tImage
            }
        })
        cell.itemPriceLabel?.text = "\u{20B9}" + String(categoryItems?[indexPath.row].itemPrice ?? 0)
        cell.storeItemNameLabel?.text = categoryItems?[indexPath.row].itemName
        cell.favButton?.tag = indexPath.row
        cell.addButton?.tag = indexPath.row
        cell.didTapProduct = self
        if categoryItems?[indexPath.row].isSelected == true {
            cell.favButton?.setImage(UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysTemplate), for: .normal)
            cell.favButton?.tintColor = .red
        } else {
            cell.favButton?.setImage(UIImage(systemName: "heart")?.withTintColor(.gray), for: .normal)
            cell.favButton?.tintColor = .lightGray
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let nunberOfCells:CGFloat = 2.5
        let spacing:CGFloat = 10
        let cellWidth = (collectionView.bounds.size.width - (spacing * nunberOfCells)) / nunberOfCells
        let height:CGFloat = 160
        return CGSize(width: cellWidth, height: height)
    }
}

extension StoreProductsTableViewCell: ProductSelectionDelegate {
    func favoriteButtonTapped(tag: Int) {
        addToFavorite?(categoryItems?[tag])
    }
    
    func addToCartTapped(tag: Int) {
        addToCart?(categoryItems?[tag])
    }
}
