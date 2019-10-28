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
        fetchData()
        initUI()
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
        #warning("TODO: Fetch real data")
        storeItems = [
        StoreItem(imageURL: "", name: "EXP Booster 1 Day", details: "This EXP booster 1 Day boosts your EXP earnings for a duration of one Earth day.", cost: 100),
        StoreItem(imageURL: "", name: "EXP Booster 1 Week", details: "This EXP booster 1 Week boosts your EXP earnings for a duration of one Earth week.", cost: 700)
        ]
    }

}
