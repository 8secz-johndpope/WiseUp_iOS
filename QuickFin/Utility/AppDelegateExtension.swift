//
//  AppDelegateExtension.swift
//  QuickFin
//
//  Created by Boyuan Xu on 9/29/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import CYLTabBarController
import Localize_Swift

// MARK: - Functions extracted from AppDelegate for better readability
extension AppDelegate {
    func makeMainTabBarController() -> MainTabBarViewController {
        // Chapters
        let chaptersVC = BaseNavigationController(rootViewController: ChapterViewController(collectionViewLayout: UICollectionViewFlowLayout()), prefersLargeTitles: false)
        // Profile
        let profileVC = BaseNavigationController(rootViewController: ProfileViewController(), prefersLargeTitles: false)
        // Setting tab bar items
        let tabBarItemsAttributes = [
            [CYLTabBarItemTitle: "Chapters".localized(),
             CYLTabBarItemImage: Images.chaptersUnselected,
             CYLTabBarItemSelectedImage: Images.chapters],
            [CYLTabBarItemTitle: "Profile".localized(),
            CYLTabBarItemImage: Images.profileUnselected,
            CYLTabBarItemSelectedImage: Images.profile]
        ]
        let tabBar = MainTabBarViewController(viewControllers: [chaptersVC, profileVC], tabBarItemsAttributes: tabBarItemsAttributes);
        tabBar.setTintColor(Colors.FidelityGreen!)
        return tabBar
    }
}

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        return self
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}

extension UIWindow {
    func setRootViewControllerWithAnimation(target: UIViewController) {
        if Core.shared.coldStart {
            Core.shared.coldStart = false
            rootViewController = target
            makeKeyAndVisible()
            return
        }
        var options = TransitionOptions()
        if #available(iOS 13.0, *) {
            options.background = TransitionOptions.Background.solidColor(UIColor.systemBackground)
        } else {
            // Fallback on earlier versions
            options.background = TransitionOptions.Background.solidColor(UIColor.white)
        }
        options.direction = .toRight
        options.style = .easeInOut
        options.duration = 0.4
        setRootViewController(target, options: options)
    }
    
}
