//
//  CategoriesFilterViewController.swift
//  MyStore
//
//  Created by Samuelabraham D on 26/07/24.
//

import UIKit

class CategoriesFilterViewController: UIViewController {
    
    @IBOutlet weak var borderView: UIView?
    @IBOutlet weak var listTableView: UITableView?
    @IBOutlet weak var bottomCloseView: UIView?
    @IBOutlet weak var closeButton: UIButton?
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint?
    
    
    var shoppingResponse: ShoppingResponse?
    var handler: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tableview = listTableView {
            configTableView(tableView: tableview)
        }
        
        bottomCloseView?.layer.cornerRadius = 20
        borderView?.layer.cornerRadius = 10
        
        var all = Categories()
        all.categoryItems = []
        all.categoryName = "All"
        all.cateogoryId = 0
        shoppingResponse?.categories?.append(all)
        let sort = shoppingResponse?.categories?.sorted(by: {($0.cateogoryId ?? 0) < ($1.cateogoryId ?? 0)})
        shoppingResponse?.categories = sort
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableViewHeight?.constant = listTableView?.contentSize.height ?? 0
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.handler?("")
    }

    private func configTableView(tableView: UITableView) {
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        let nib = UINib(nibName: "CategoryFilterTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "CategoryFilterTableViewCell")
    }
}

extension CategoriesFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingResponse?.categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryFilterTableViewCell", for: indexPath) as? CategoryFilterTableViewCell else { return CategoryFilterTableViewCell()}
        cell.categoryTypeLabel?.text = shoppingResponse?.categories?[indexPath.row].categoryName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handler?(shoppingResponse?.categories?[indexPath.row].categoryName ?? "")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
