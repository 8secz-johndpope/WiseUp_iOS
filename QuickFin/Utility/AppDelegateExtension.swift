//
//  AppDelegateExtension.swift
//  QuickFin
//
//  Created by Boyuan Xu on 9/29/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import CYLTabBarController

// MARK: - Functions extracted from AppDelegate for better readability
extension AppDelegate {
    func makeMainTabBarController() -> MainTabBarViewController {
        let chaptersVC = BaseNavigationController(rootViewController: ChapterViewController(collectionViewLayout: UICollectionViewFlowLayout()), prefersLargeTitles: false)
        let profileVC = BaseNavigationController(rootViewController: ProfileViewController(), prefersLargeTitles: false)
        let tabBarItemsAttributes = [
            [CYLTabBarItemTitle: "Chapters",
             CYLTabBarItemImage: Images.chaptersUnselected,
             CYLTabBarItemSelectedImage: Images.chapters],
            [CYLTabBarItemTitle: "Profile",
            CYLTabBarItemImage: Images.profileUnselected,
            CYLTabBarItemSelectedImage: Images.profile]
        ]
        return MainTabBarViewController(viewControllers: [chaptersVC, profileVC], tabBarItemsAttributes: tabBarItemsAttributes)
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
