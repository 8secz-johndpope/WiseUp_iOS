//
//  StoreItemDetailsViewController.swift
//  QuickFin
//
//  Created by Boyuan Xu on 10/28/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit

class StoreItemDetailsViewController: BaseViewController {
    
    var buyButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var item: StoreItem! {
        didSet {
            initUI(image: FirebaseService.shared.getImage(URL: self.item.imageName), title: self.item.name, details: self.item.details, cost: self.item.cost)
        }
    }
    
}

extension StoreItemDetailsViewController {
    
    func buyItem() {
        
        if !UserShared.shared.avatarsOwned.contains(item.name) {
            
            //  check if user has enough funds to purchase
            
            UserShared.shared.avatarsOwned.append(item.name)
            FirebaseService.shared.pushUserToFirebase()
            
            buyButton!.setTitle("Already Owned".localized(), for: .normal)
            
            // Prompt user to equip their new avatar?
            #warning("TO DO - Prompt user to equip new avatar")
            
            
            
        }
        
    }
    
}
