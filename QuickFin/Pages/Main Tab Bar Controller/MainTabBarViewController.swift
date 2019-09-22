//
//  MainTabBarViewController.swift
//  QuickFin
//
//  Created by Boyuan Xu on 9/18/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController
import FirebaseAuth
import FBSDKLoginKit

class MainTabBarViewController: RAMAnimatedTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        
        // MARK: - Debug use only, logs out after 2 seconds, remove when logout button implemented
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if Auth.auth().currentUser == nil {
                UIApplication.shared.keyWindow?.setRootViewControllerWithAnimation(target: SignInViewController())
                return
            }
            do {
                try Auth.auth().signOut()
                LoginManager().logOut()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }

}

