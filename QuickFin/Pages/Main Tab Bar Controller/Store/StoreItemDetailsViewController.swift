//
//  StoreItemDetailsViewController.swift
//  QuickFin
//
//  Created by Boyuan Xu on 10/28/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import SwiftMessages
import Bond

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
    
    weak var itemsViewDelegate: ItemsViewDelegate!
    
    var showConsume: Bool? {
        didSet {
            buyButton?.setTitle("Use".localized(), for: .normal)
            _ = buyButton?.reactive.tap.observeNext(with: { [unowned self] (_) in
                self.consumeItem()
                self.itemsViewDelegate.didConsume()
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
}

extension StoreItemDetailsViewController {
    
    func consumeItem() {
        UserShared.shared.itemsOwned = UserShared.shared.itemsOwned.filter({ $0 != item.name })
        UserShared.shared.activeItem = item
        FirebaseService.shared.pushUserToFirebase()
    }
    
    func buyItem() {
        
        if item.type == "avatar" {
            
            if !UserShared.shared.avatarsOwned.contains(item.name) {
            
                //  check if user has enough funds to purchase
            
                if !(UserShared.shared.coins >= item.cost) {
                    
                    let prompt: MessageView = {
                        let mv = MessageView.viewFromNib(layout: .cardView)
                        mv.configureTheme(.error)
                        mv.configureDropShadow()
                        mv.configureContent(title: "Error!".localized(), body: "Not Enough Coins".localized())  // Error messages are typically pre-localized
                        mv.button?.setTitle("Okay".localized(), for: .normal)
                       
                        _ = mv.button?.reactive.tap.observeNext(with: { (_) in
                                  SwiftMessages.hide()
                       })
                        return mv
                    }()
                    var config = SwiftMessages.Config()
                    config.presentationContext = .window(windowLevel: .statusBar)
                    config.preferredStatusBarStyle = .lightContent
                    SwiftMessages.show(config: config, view: prompt)
                    
                    print("Not enough coins for avatar")
                    
                } else {
                    
                    UserShared.shared.coins -= item.cost
                    UserShared.shared.avatarsOwned.append(item.name)
                    FirebaseService.shared.pushUserToFirebase()
                    
                    buyButton!.setTitle("Already Owned".localized(), for: .normal)
                    
                    let prompt: MessageView = {
                        let mv = MessageView.viewFromNib(layout: .cardView)
                        mv.configureTheme(.success)
                        mv.configureDropShadow()
                        mv.configureContent(title: "Success".localized(), body: "Would you like to equip this avatar?".localized())  // Error messages are typically pre-localized
                        mv.button?.setTitle("Yes".localized(), for: .normal)
                        _ = mv.button?.reactive.tap.observeNext(with: { [unowned self] (_) in
                            UserShared.shared.avatar = self.item.name
                            FirebaseService.shared.pushUserToFirebase()
                            SwiftMessages.hide()
                            self.dismiss(animated: true, completion: nil)
                        })
                        return mv
                    }()
                    var config = SwiftMessages.Config()
                    config.presentationContext = .window(windowLevel: .statusBar)
                    config.preferredStatusBarStyle = .lightContent
                    SwiftMessages.show(config: config, view: prompt)
                }
                
            }
            
        } else {
            
            if !UserShared.shared.itemsOwned.contains(item.name) {
            
                //  check if user has enough funds to purchase
            
                if !(UserShared.shared.coins >= item.cost) {
                    
                     let prompt: MessageView = {
                         let mv = MessageView.viewFromNib(layout: .cardView)
                         mv.configureTheme(.error)
                         mv.configureDropShadow()
                         mv.configureContent(title: "Error!".localized(), body: "Not Enough Coins".localized())  // Error messages are typically pre-localized
                         mv.button?.setTitle("Okay".localized(), for: .normal)
                        
                         _ = mv.button?.reactive.tap.observeNext(with: { (_) in
                                   SwiftMessages.hide()
                        })
                         return mv
                     }()
                     var config = SwiftMessages.Config()
                     config.presentationContext = .window(windowLevel: .statusBar)
                     config.preferredStatusBarStyle = .lightContent
                     SwiftMessages.show(config: config, view: prompt)
                    
                     print("Not enough coins for consumable")
                    
                } else {
                    
                    UserShared.shared.coins -= item.cost
                    UserShared.shared.itemsOwned.append(item.name)
                    FirebaseService.shared.pushUserToFirebase()
                    
                    buyButton!.setTitle("Already Owned".localized(), for: .normal)
                
                }
            }
        }
        
    }
    
}
