//
//  ItemsViewController.swift
//  QuickFin
//
//  Created by Boyuan Xu on 12/1/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit

protocol ItemsViewDelegate: class {
    func didConsume()
}

class ItemsViewController: StoreViewController, ItemsViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Items".localized()
        
        segmentedControl.isHidden = true
        
        tableView.snp.makeConstraints { (this) in
            this.leading.equalToSuperview()
            this.top.equalTo(view.snp.topMargin).offset(5)
            this.bottom.equalTo(view.snp.bottomMargin)
            this.trailing.equalToSuperview()
        }
        
    }
    
    func didConsume() {
        fetchData()
    }
    
    override func fetchData() {
        
        // First Get Pre-Cached Chapters (or empty if nothing cached)
        storeItems = CacheService.shared.getCachedStore()
        
        consumableItems = []
        
        for sItem in storeItems {
            if sItem.type == "consumable" {
                if UserShared.shared.itemsOwned.contains(sItem.name) {
                    consumableItems.append(sItem)
                }
            }
        }
        
        storeItems = consumableItems
        self.tableView.reloadData()
        
        // Second, asynchronously check for updates to chapters and download them if needed
        CacheService.shared.getStore { [unowned self] (store) in
            self.storeItems = store
            
            self.consumableItems = []
            
            for sItem in self.storeItems {
                if sItem.type == "consumable" {
                    if UserShared.shared.itemsOwned.contains(sItem.name) {
                        self.consumableItems.append(sItem)
                    }
                }
            }
            
            self.storeItems = self.consumableItems
            
            self.tableView.reloadData()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailsVC = StoreItemDetailsViewController()
        detailsVC.item = storeItems[indexPath.row]
        detailsVC.showConsume = true
        detailsVC.itemsViewDelegate = self
        present(detailsVC, animated: true) {}
    }

}
