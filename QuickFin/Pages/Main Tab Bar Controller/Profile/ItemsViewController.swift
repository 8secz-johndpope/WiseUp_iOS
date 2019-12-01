//
//  ItemsViewController.swift
//  QuickFin
//
//  Created by Boyuan Xu on 12/1/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit

class ItemsViewController: StoreViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Items".localized()
    }
    
    override func fetchData() {
        #warning("TODO: Fetch data for items")
    }

}
