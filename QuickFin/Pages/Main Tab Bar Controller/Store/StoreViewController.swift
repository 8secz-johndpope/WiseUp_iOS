//
//  StoreViewController.swift
//  QuickFin
//
//  Created by Connor Buckley on 10/14/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit

class StoreViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Store".localized()
        setBackground()
        initUI()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    var tableView: UITableView!
    let reuseID = "store"
    var storeItems = [StoreItem]()
    let storeSortingOptions = [
        "Hot".localized(),
        "New".localized(),
        "Pricy".localized(),
        "Cheap".localized()
    ]
        
    func fetchData() {
        
        // First Get Pre-Cached Chapters (or empty if nothing cached)
        storeItems = CacheService.shared.getCachedStore()
        
        print(storeItems)
        
        self.tableView.reloadData()
        
        // Second, asynchronously check for updates to chapters and download them if needed
        CacheService.shared.getStore { [unowned self] (store) in
            self.storeItems = store
            self.tableView.reloadData()
        }
    
    }

}
