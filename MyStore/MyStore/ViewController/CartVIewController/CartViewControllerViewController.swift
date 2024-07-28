//
//  FavoriteListViewController.swift
//  MyStore
//
//  Created by Samuelabraham D on 26/07/24.
//

import UIKit

class CartViewControllerViewController: UIViewController {
    
    @IBOutlet weak var cartTableView: UITableView?
    @IBOutlet weak var subCountLabel: UILabel?
    @IBOutlet weak var discountLabel: UILabel?
    @IBOutlet weak var totalLabel: UILabel?
    @IBOutlet weak var priceListView: UIStackView?
    @IBOutlet weak var checkoutButton: UIButton?
    @IBOutlet weak var emptyView: UIView?
    @IBOutlet weak var priceDetailsView: UIView?
    @IBOutlet weak var checkoutView: UIView?
    
    
    var categoryItems: [CategoryItems]?
    let service = CartListServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tTableView = cartTableView {
            configTableView(tableView: tTableView)
        }
        if let response = service.fetchCartList()?.first?.convertToCartList(entity: service.fetchCartList()) {
            categoryItems = response
            cartTableView?.reloadData()
            showEmptyMessage(isNeed: false)
        } else {
            showEmptyMessage(isNeed: true)
        }
        checkoutButton?.layer.cornerRadius = 8
        priceListView?.layer.cornerRadius = 10
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calculation()
    }
    
    private func configTableView(tableView: UITableView) {
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        let nib = UINib(nibName: "CartTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "CartTableViewCell")
    }
    
    @IBAction func leftButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func checkoutButtonTapped(_ sender: UIButton) {
        print("Success!!!")
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        let tag = sender.tag
        if var items = categoryItems, items.indices.contains(tag) {
            var item = items[tag]
            item.quantity = (item.quantity ?? 0) + 1
            item.totalPrice = (Double(item.quantity ?? 0) * (item.itemPrice ?? 0.0))
            
            items[tag] = item
            service.saveCartList(cartList: items)
            categoryItems = items
        }
        cartTableView?.reloadData()
        calculation()
    }
    
    @objc func minusButtonTapped(_ sender: UIButton) {
        let tag = sender.tag
        if var items = categoryItems, items.indices.contains(tag) {
            var item = items[tag]
            item.quantity = (item.quantity ?? 0) - 1
            
            items[tag] = item
            if item.quantity == 0 {
                service.deleteCartItem(id: String(item.itemId ?? 0)) {
                    if let response = self.service.fetchCartList()?.first?.convertToCartList(entity: self.service.fetchCartList()) {
                        self.categoryItems = response
                    } else {
                        self.categoryItems = []
                        self.showEmptyMessage(isNeed: true)
                    }
                    self.cartTableView?.reloadData()
                    self.calculation()
                }
            } else {
                service.saveCartList(cartList: items)
                categoryItems = items
                cartTableView?.reloadData()
                calculation()
            }
        }
    }
    
    func calculation() {
        let sum = categoryItems?.map { $0.totalPrice ?? 0.0 }.reduce(0.0, +)
        self.subCountLabel?.text = "\u{20B9}" + "\(sum ?? 0)"
        self.discountLabel?.text = "-40"
        self.totalLabel?.text = "\u{20B9}" + "\((sum ?? 0) - 40)"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "CartList"), object: nil)
    }
    
    private func showEmptyMessage(isNeed: Bool) {
        emptyView?.isHidden = !isNeed
        checkoutView?.isHidden = isNeed
        priceDetailsView?.isHidden = isNeed
        cartTableView?.isHidden = isNeed
    }
}

extension CartViewControllerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as? CartTableViewCell else { return CartTableViewCell()}
        cell.itemNameLabel?.text = categoryItems?[indexPath.row].itemName
        cell.itemPriceLabel?.text = "\u{20B9}" + String(categoryItems?[indexPath.row].itemPrice ?? 0)
        cell.plusButton?.tag = indexPath.row
        cell.minusButton?.tag = indexPath.row
        cell.plusButton?.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        cell.minusButton?.addTarget(self, action: #selector(minusButtonTapped(_:)), for: .touchUpInside)
        categoryItems?[indexPath.row].itemIcons?.getImageFromURL(completion: { image in
            if let tImage = image {
                cell.itemImageView?.image = tImage
            }
        })
        cell.quantityLabel?.text = "\(categoryItems?[indexPath.row].quantity ?? 0)"
        cell.productTotalPriceLabel?.text = "\u{20B9}" + "\(Double((categoryItems?[indexPath.row].quantity ?? 0)) * (categoryItems?[indexPath.row].itemPrice ?? 0))"
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
