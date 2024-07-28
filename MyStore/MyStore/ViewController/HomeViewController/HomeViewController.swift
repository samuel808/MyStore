//
//  ViewController.swift
//  MyStore
//
//  Created by Samuelabraham D on 25/07/24.
//

import UIKit

protocol ProductSelectionDelegate {
    func favoriteButtonTapped(tag: Int)
    func addToCartTapped(tag: Int)
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var cartCountLabel: UILabel?
    @IBOutlet weak var categoryView: UIView?
    @IBOutlet weak var storeTableView: UITableView?
    @IBOutlet weak var navigationBarView: UIView?
    
    var shoppingResponse: ShoppingResponse?
    let service = CategoryListServices()
    let favService = FavoriteListServices()
    let cartServise = CartListServices()
    var filterShoppingDetail: [Categories]?
    var isFilter: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarView?.gradientLayer.colors = [UIColor(hex: "FAA03D").cgColor, UIColor(hex: "FACC34").cgColor]
        navigationBarView?.gradientLayer.gradient = GradientPoint.topBottom.draw()
        
        if let tableView = storeTableView {
            configTableView(tableView: tableView)
        }
        getStoreDataList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayCartCount()
        addObserverNotification()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        categoryView?.layer.cornerRadius = 8
        cartCountLabel?.layer.cornerRadius = 7.5
        cartCountLabel?.layer.masksToBounds = true
        navigationBarView?.layer.cornerRadius = 12
    }
    
    private func configTableView(tableView: UITableView) {
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        let nib = UINib(nibName: "StoreProductsTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "StoreProductsTableViewCell")
        let nib2 = UINib.init(nibName: "StoreProductHeaderView", bundle: nil)
        tableView.register(nib2, forHeaderFooterViewReuseIdentifier: "StoreProductHeaderView")
    }

    @IBAction func favButtonTapped(_ sender: UIButton) {
        gotoFavoritePage()
    }
    
    @IBAction func cartButtonTapped(_ sender: UIButton) {
        gotoCartPage()
    }
    @IBAction func categoryButtonTapped(_ sender: UIButton) {
        categoryView?.isHidden = true
        gotoCategoryFilterPage(shoppingResponse: self.shoppingResponse) { filter in
            self.dismiss(animated: true) {
                self.isFilter = (filter == "All" || filter ==  "") ? false : true
                self.categoryView?.isHidden = false
                self.filterShoppingDetail = self.shoppingResponse?.categories?.filter({$0.categoryName == filter})
                self.storeTableView?.reloadData()
            }
        }
    }
    
    func gotoCategoryFilterPage(shoppingResponse: ShoppingResponse?, handler: ((String) -> Void)?) {
        let destinationVc = CategoriesFilterViewController(nibName: "CategoriesFilterViewController", bundle: Bundle.main)
        destinationVc.shoppingResponse = shoppingResponse
        destinationVc.handler = handler
        destinationVc.modalPresentationStyle = .overFullScreen
        self.present(destinationVc, animated: true, completion: nil)
    }
    
    @objc func expandButtonTapped(_ sender: UIButton) {
        guard var categories = shoppingResponse?.categories else { return }
        categories[sender.tag].isExpand?.toggle()
        shoppingResponse?.categories = categories
        storeTableView?.reloadData()
    }
    
    func gotoCartPage() {
        let destinationVc = CartViewControllerViewController(nibName: "CartViewControllerViewController", bundle: Bundle.main)
        destinationVc.modalPresentationStyle = .overFullScreen
        self.present(destinationVc, animated: true, completion: nil)
    }
    
    func gotoFavoritePage() {
        let destinationVc = FavoriteListViewController(nibName: "FavoriteListViewController", bundle: Bundle.main)
        destinationVc.modalPresentationStyle = .overFullScreen
        self.present(destinationVc, animated: true, completion: nil)
    }
    
    @objc func displayCartCount() {
        let cartList = cartServise.fetchCartList()?.first?.convertToCartList(entity: cartServise.fetchCartList())
        cartCountLabel?.text = "\(cartList?.count ?? 0)"
        cartCountLabel?.isHidden = (cartList?.count == 0 || cartList?.count == nil) ? true : false
    }
    
    @objc func getStoreDataList() {
        if let response = service.fetchCategoryList()?.first?.convertToCategoryItemList(entity: service.fetchCategoryList()) {
            let shopResponse = ShoppingResponse(categories: response)
            shoppingResponse = shopResponse
            storeTableView?.reloadData()
        } else {
            if let shoppingRes = Manager.shared.getShoppingResponse() {
                DispatchQueue.main.async {
                    self.service.saveCategoryList(categoryList: shoppingRes.categories)
                }
                shoppingResponse = shoppingRes
            }
        }
    }
    
    func addObserverNotification() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "CartList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(displayCartCount), name: Notification.Name(rawValue: "CartList"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "FavoriteList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getStoreDataList), name: Notification.Name(rawValue: "FavoriteList"), object: nil)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isFilter ? (filterShoppingDetail?.count ?? 0) : (shoppingResponse?.categories?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isFilter {
            if (filterShoppingDetail?.count ?? 0) > section {
                if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "StoreProductHeaderView") as? StoreProductHeaderView {
                    headerView.titleLabel?.text = filterShoppingDetail?[section].categoryName
                    headerView.expandButton?.setImage(UIImage(systemName: filterShoppingDetail?[section].isExpand == true ? "chevron.up" : "chevron.down"), for: .normal)
                    headerView.expandButton?.tag = section
                    headerView.expandButton?.addTarget(self, action: #selector(expandButtonTapped(_:)), for: .touchUpInside)
                    return headerView
                }
                return nil
            }
            return nil
        } else {
            if (shoppingResponse?.categories?.count ?? 0) > section {
                if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "StoreProductHeaderView") as? StoreProductHeaderView {
                    headerView.titleLabel?.text = shoppingResponse?.categories?[section].categoryName
                    headerView.expandButton?.setImage(UIImage(systemName: shoppingResponse?.categories?[section].isExpand == true ? "chevron.up" : "chevron.down"), for: .normal)
                    headerView.expandButton?.tag = section
                    headerView.expandButton?.addTarget(self, action: #selector(expandButtonTapped(_:)), for: .touchUpInside)
                    return headerView
                }
                return nil
            }
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isFilter == false{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StoreProductsTableViewCell", for: indexPath) as? StoreProductsTableViewCell else { return StoreProductsTableViewCell()}
            cell.categoryItems = shoppingResponse?.categories?[indexPath.section].categoryItems
            cell.addToFavorite = { (item) in
                if let index = self.shoppingResponse?.categories?[indexPath.section].categoryItems?.firstIndex(where: {$0.itemId == item?.itemId}) {
                    if self.shoppingResponse?.categories?[indexPath.section].categoryItems?[index].isSelected == true {
                        self.shoppingResponse?.categories?[indexPath.section].categoryItems?[index].isSelected = false
                        self.favService.deleteFavoriteItem(id: String(self.shoppingResponse?.categories?[indexPath.section].categoryItems?[index].itemId ?? 0))
                    } else {
                        self.shoppingResponse?.categories?[indexPath.section].categoryItems?[index].isSelected = true
                        if let favList = self.favService.fetchFavoriteList()?.first?.convertToFavoriteList(entity: self.favService.fetchFavoriteList()) {
                            var tFavList = favList
                            if tFavList.filter({$0.itemId == self.shoppingResponse?.categories?[indexPath.section].categoryItems?[index].itemId}).count <= 0 {
                                if let tData = self.shoppingResponse?.categories?[indexPath.section].categoryItems?[index] {
                                    tFavList.append(tData)
                                    self.favService.saveFavoriteList(favoriteList: tFavList)
                                }
                            }
                        } else {
                            var tFavList: [CategoryItems] = []
                            if let tData = self.shoppingResponse?.categories?[indexPath.section].categoryItems?[index] {
                                tFavList.append(tData)
                            }
                            self.favService.saveFavoriteList(favoriteList: tFavList)
                        }
                    }
                }
                self.storeTableView?.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
                self.service.saveCategoryList(categoryList: self.shoppingResponse?.categories)
            }
            
            cell.addToCart = { (item) in
                if let index = self.shoppingResponse?.categories?[indexPath.section].categoryItems?.firstIndex(where: {$0.itemId == item?.itemId}) {
                    if let cartList = self.cartServise.fetchCartList()?.first?.convertToCartList(entity: self.cartServise.fetchCartList()) {
                        var tCartList = cartList
                        if tCartList.filter({$0.itemId == self.shoppingResponse?.categories?[indexPath.section].categoryItems?[index].itemId}).count <= 0 {
                            if var tData = self.shoppingResponse?.categories?[indexPath.section].categoryItems?[index] {
                                tData.quantity = 1
                                tCartList.append(tData)
                                self.cartServise.saveCartList(cartList: tCartList)
                            }
                        }
                    } else {
                        var tCartList: [CategoryItems] = []
                        if var tData = self.shoppingResponse?.categories?[indexPath.section].categoryItems?[index] {
                            tData.quantity = 1
                            tCartList.append(tData)
                        }
                        self.cartServise.saveCartList(cartList: tCartList)
                    }
                }
                self.displayCartCount()
            }
            
            if shoppingResponse?.categories?[indexPath.section].isExpand == true {
                cell.isHidden = false
            } else {
                cell.isHidden = true
            }
            cell.selectionStyle = .none
            cell.layoutIfNeeded()
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StoreProductsTableViewCell", for: indexPath) as? StoreProductsTableViewCell else { return StoreProductsTableViewCell()}
            cell.categoryItems = filterShoppingDetail?[indexPath.section].categoryItems
            cell.addToFavorite = { (item) in
                if let index = self.filterShoppingDetail?[indexPath.section].categoryItems?.firstIndex(where: {$0.itemId == item?.itemId}) {
                    if self.filterShoppingDetail?[indexPath.section].categoryItems?[index].isSelected == true {
                        self.filterShoppingDetail?[indexPath.section].categoryItems?[index].isSelected = false
                        self.favService.deleteFavoriteItem(id: String(self.filterShoppingDetail?[indexPath.section].categoryItems?[index].itemId ?? 0))
                    } else {
                        self.filterShoppingDetail?[indexPath.section].categoryItems?[index].isSelected = true
                        if let favList = self.favService.fetchFavoriteList()?.first?.convertToFavoriteList(entity: self.favService.fetchFavoriteList()) {
                            var tFavList = favList
                            if tFavList.filter({$0.itemId == self.filterShoppingDetail?[indexPath.section].categoryItems?[index].itemId}).count <= 0 {
                                if let tData = self.filterShoppingDetail?[indexPath.section].categoryItems?[index] {
                                    tFavList.append(tData)
                                    self.favService.saveFavoriteList(favoriteList: tFavList)
                                }
                            }
                        } else {
                            var tFavList: [CategoryItems] = []
                            if let tData = self.filterShoppingDetail?[indexPath.section].categoryItems?[index] {
                                tFavList.append(tData)
                            }
                            self.favService.saveFavoriteList(favoriteList: tFavList)
                        }
                    }
                }
                self.storeTableView?.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
                if let index = self.shoppingResponse?.categories?.firstIndex(where: {$0.categoryName == self.filterShoppingDetail?[indexPath.section].categoryName}) {
                    if let data = self.filterShoppingDetail?.first {
                        self.shoppingResponse?.categories?[index] = data
                    }
                }
                self.service.saveCategoryList(categoryList: self.shoppingResponse?.categories)
            }
            
            cell.addToCart = { (item) in
                if let index = self.filterShoppingDetail?[indexPath.section].categoryItems?.firstIndex(where: {$0.itemId == item?.itemId}) {
                    if let cartList = self.cartServise.fetchCartList()?.first?.convertToCartList(entity: self.cartServise.fetchCartList()) {
                        var tCartList = cartList
                        if tCartList.filter({$0.itemId == self.filterShoppingDetail?[indexPath.section].categoryItems?[index].itemId}).count <= 0 {
                            if var tData = self.filterShoppingDetail?[indexPath.section].categoryItems?[index] {
                                tData.quantity = 1
                                tCartList.append(tData)
                                self.cartServise.saveCartList(cartList: tCartList)
                            }
                        }
                    } else {
                        var tCartList: [CategoryItems] = []
                        if var tData = self.filterShoppingDetail?[indexPath.section].categoryItems?[index] {
                            tData.quantity = 1
                            tCartList.append(tData)
                        }
                        self.cartServise.saveCartList(cartList: tCartList)
                    }
                }
                self.displayCartCount()
            }
            
            if filterShoppingDetail?[indexPath.section].isExpand == true {
                cell.isHidden = false
            } else {
                cell.isHidden = true
            }
            cell.selectionStyle = .none
            cell.layoutIfNeeded()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isFilter {
            return filterShoppingDetail?[indexPath.section].isExpand == true ? 160 : 0
        } else {
            return shoppingResponse?.categories?[indexPath.section].isExpand == true ? 160 : 0
        }
    }
}
