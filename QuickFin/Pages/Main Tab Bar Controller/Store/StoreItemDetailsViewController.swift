//
//  StoreItemDetailsViewController.swift
//  QuickFin
//
//  Created by Boyuan Xu on 10/28/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit

class StoreItemDetailsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var item: StoreItem! {
        didSet {
            initUI(image: FirebaseService.shared.getImage(URL: self.item.imageURL), title: self.item.name, details: self.item.details, cost: self.item.cost)
        }
    }
    
}

extension StoreItemDetailsViewController {
    
    func buyItem() {
        #warning("TODO: Buying item logic")
    }
    
}
