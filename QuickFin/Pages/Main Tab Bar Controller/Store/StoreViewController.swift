//
//  StoreViewController.swift
//  QuickFin
//
//  Created by Connor Buckley on 10/14/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit

class CustomSegmentedControl: UISegmentedControl {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 0
    }
}

class StoreViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Store".localized()
        setBackground()
        initUI()
        addControl()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    
    let refreshControl = UIRefreshControl()
    var tableView: UITableView!
    let reuseID = "store"
    var storeItems = [StoreItem]()
    let storeSortingOptions = [
        "Hot".localized(),
        "New".localized(),
        "Pricy".localized(),
        "Cheap".localized()
    ]
    
    var avatarItems = [StoreItem]()
    var consumableItems = [StoreItem]()
    var stockItems = [StoreItem]()
    
    let segmentedControl = CustomSegmentedControl(items: ["Avatars", "Items", "Stocks"])
    
    func addControl()  {
                
        segmentedControl.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = Colors.DynamicNavigationBarColor
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Colors.DynamicNavigationTitleColor!], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Colors.FidelityGreen!], for: .selected)
        segmentedControl.layer.borderColor = UIColor.white.cgColor
        segmentedControl.layer.borderWidth = 0.0
        segmentedControl.layer.masksToBounds = true
                
        view.addSubview(segmentedControl)
        
        segmentedControl.snp.makeConstraints { (this) in
            this.leading.equalToSuperview()
            this.top.equalTo(view.snp.topMargin)
            this.height.equalTo(40)
            this.trailing.equalToSuperview()
        }

    }

    @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            storeItems = avatarItems
            tableView.reloadData()
            break // Uno
        case 1:
            storeItems = consumableItems
            tableView.reloadData()
            break // Dos
        case 2:
            storeItems = stockItems
            tableView.reloadData()
            break
        
        default:
            break
        }
    }
        
    @objc func fetchData() {
        
        // First Get Pre-Cached Chapters (or empty if nothing cached)
        storeItems = CacheService.shared.getCachedStore()
        
        avatarItems = []
        consumableItems = []
        stockItems = []
        
        for sItem in storeItems {
            if sItem.type == "avatar" {
                avatarItems.append(sItem)
            } else if sItem.type == "consumable" {
                consumableItems.append(sItem)
            } else if sItem.type == "stock" {
                stockItems.append(sItem)
            }
        }
        
        if segmentedControl.selectedSegmentIndex == 0 {
            storeItems = avatarItems
        } else if segmentedControl.selectedSegmentIndex == 1 {
            storeItems = consumableItems
        } else if segmentedControl.selectedSegmentIndex == 2 {
            storeItems = stockItems
        }
        
        
        self.tableView.reloadData()
        
        // Second, asynchronously check for updates to chapters and download them if needed
        CacheService.shared.getStore { [unowned self] (store) in
            self.storeItems = store
            
            self.avatarItems = []
            self.consumableItems = []
            self.stockItems = []
            
            for sItem in self.storeItems {
                if sItem.type == "avatar" {
                    self.avatarItems.append(sItem)
                } else if sItem.type == "consumable" {
                    self.consumableItems.append(sItem)
                } else if sItem.type == "stock" {
                    self.stockItems.append(sItem)
                }
            }
            
            if self.segmentedControl.selectedSegmentIndex == 0 {
                self.storeItems = self.avatarItems
            } else if self.segmentedControl.selectedSegmentIndex == 1 {
                self.storeItems = self.consumableItems
            } else if self.segmentedControl.selectedSegmentIndex == 2 {
                self.storeItems = self.stockItems
            }
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    
    }

}
