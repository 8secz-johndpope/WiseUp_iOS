//
//  MainTabBarViewController.swift
//  QuickFin
//
//  Created by Boyuan Xu on 9/18/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

class MainTabBarViewController: RAMAnimatedTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        
//        let layout = UICollectionViewFlowLayout()
//        let chapterController = ChapterViewController(collectionViewLayout: layout)
//        let chapterNavController = UINavigationController(rootViewController: chapterController)
//
//        let profileController = ProfileViewController()
//        let profileNavController = UINavigationController(rootViewController: profileController)
//
//        chapterNavController.tabBarItem.title = "Chapters"
//        profileNavController.tabBarItem.title = "Profile"
//
//        viewControllers = [chapterNavController, profileNavController]
        addChildViewController(rootViewController: ChapterViewController(collectionViewLayout: UICollectionViewFlowLayout()), prefersLargeTitles: false, title: "Chapters", image: nil, selectedImage: nil)
        addChildViewController(rootViewController: ProfileViewController(), prefersLargeTitles: false, title: "Profile", image: nil, selectedImage: nil)
    }

}


// MARK: - UI
extension MainTabBarViewController {
    
    private func addChildViewController(rootViewController: UIViewController, prefersLargeTitles: Bool, title: String?, image: UIImage?, selectedImage: UIImage?) {
        // Add BaseNavigationController
        let nav = BaseNavigationController(rootViewController: rootViewController, prefersLargeTitles: prefersLargeTitles)
        viewControllers?.append(nav)
        
        // Add bar item
        nav.tabBarItem = RAMAnimatedTabBarItem(title: title, image: image, selectedImage: selectedImage)
    }
    
}
