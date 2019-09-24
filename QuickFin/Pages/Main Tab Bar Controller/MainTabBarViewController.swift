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

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        
        let layout = UICollectionViewFlowLayout()
        let chapterController = ChapterViewController(collectionViewLayout: layout)
        let chapterNavController = UINavigationController(rootViewController: chapterController)
        
        let profileController = ProfileViewController()
        let profileNavController = UINavigationController(rootViewController: profileController)
        
        chapterNavController.tabBarItem.title = "Chapters"
        profileNavController.tabBarItem.title = "Profile"
        
        viewControllers = [chapterNavController, profileNavController]
    }

}

