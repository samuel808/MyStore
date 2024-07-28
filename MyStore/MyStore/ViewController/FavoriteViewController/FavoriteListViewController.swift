//
//  CartViewControllerViewController.swift
//  MyStore
//
//  Created by Samuelabraham D on 26/07/24.
//

import UIKit

class FavoriteListViewController: UIViewController {
    
    @IBOutlet weak var leftArrowButton: UIButton?
    @IBOutlet weak var favoriteTableview: UITableView?
    @IBOutlet weak var emptyMessageView: UIView?
    
    var categoryItems: [CategoryItems]?
    let service = FavoriteListServices()
    let cartService = CartListServices()
    let categoryService = CategoryListServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tTableView = favoriteTableview {
            configTableView(tableView: tTableView)
        }
        if let response = service.fetchFavoriteList()?.first?.convertToFavoriteList(entity: service.fetchFavoriteList()) {
            categoryItems = response
            favoriteTableview?.reloadData()
            showEmptyMessage(isNeed: false)
        } else {
            showEmptyMessage(isNeed: true)
        }
    }
    
    @IBAction func leftArrowTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    private func configTableView(tableView: UITableView) {
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        let nib = UINib(nibName: "FavoriteTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "FavoriteTableViewCell")
    }
    
    private func showEmptyMessage(isNeed: Bool) {
        emptyMessageView?.isHidden = !isNeed
        favoriteTableview?.isHidden = isNeed
    }
    
    @objc func favButtonTapped(_ sender: UIButton) {
        let tag = sender.tag
        if let items = categoryItems, items.indices.contains(tag) {
            let item = items[tag]
            service.deleteFavoriteItem(id: String(item.itemId ?? 0)) {
                if let response = self.service.fetchFavoriteList()?.first?.convertToFavoriteList(entity: self.service.fetchFavoriteList()) {
                    self.categoryItems = response
                    self.favoriteTableview?.reloadData()
                } else {
                    self.showEmptyMessage(isNeed: true)
                }
                
                if let cData = self.categoryService.fetchCategoryList()?.first?.convertToCategoryItemList(entity: self.categoryService.fetchCategoryList()) {
                    let categoryData = cData
                    for int in 0..<categoryData.count {
                        if let _ = categoryData[int].categoryItems?.firstIndex(where: {$0.itemId == item.itemId}) {
                            self.categoryService.updateCategoryDetail(id: String(categoryData[int].cateogoryId ?? 0), itemId: String(item.itemId ?? 0)) {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "FavoriteList"), object: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        let tag = sender.tag
        if let items = categoryItems, items.indices.contains(tag) {
            let item = items[tag]
            if let data = cartService.fetchCartList()?.first?.convertToCartList(entity: cartService.fetchCartList()) {
                var cartItem = data
                cartItem.append(item)
                cartService.saveCartList(cartList: cartItem)
            } else {
                var cartItem: [CategoryItems] = []
                cartItem.append(item)
                cartService.saveCartList(cartList: cartItem)
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: "CartList"), object: nil)
        }
    }
}

extension FavoriteListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell", for: indexPath) as? FavoriteTableViewCell else { return FavoriteTableViewCell()}
        cell.productNameLabel?.text = categoryItems?[indexPath.row].itemName
        cell.productPriceLabel?.text = "\u{20B9}" + String(categoryItems?[indexPath.row].itemPrice ?? 0)
        cell.favButton?.tag = indexPath.row
        cell.addButton?.tag = indexPath.row
        
        cell.favButton?.addTarget(self, action: #selector(favButtonTapped(_:)), for: .touchUpInside)
        cell.addButton?.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        categoryItems?[indexPath.row].itemIcons?.getImageFromURL(completion: { image in
            if let tImage = image {
                cell.productImageView?.image = tImage
            }
        })
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
