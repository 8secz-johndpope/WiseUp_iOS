//
//  AppDelegate.swift
//  QuickFin
//
//  Created by Boyuan Xu on 9/18/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import IQKeyboardManagerSwift
import UIWindowTransitions
import CYLTabBarController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        IQKeyboardManager.shared.enable = true
        
        // MARK: - Programmatically initialize UI
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            // This state listener should persist.
            Auth.auth().addStateDidChangeListener { [unowned self] (_, user) in
                if user != nil {
                    window.setRootViewControllerWithAnimation(target: self.makeMainTabBarController())
                } else {
                    window.setRootViewControllerWithAnimation(target: SignInViewController())
                }
            }
        }
        return true
    }
    
    func makeMainTabBarController() -> MainTabBarViewController {
        let chaptersVC = makeChildViewController(rootViewController: ChapterViewController(collectionViewLayout: UICollectionViewFlowLayout()), prefersLargeTitles: false, title: "Chapters", image: Images.chaptersUnselected, selectedImage: Images.chapters)
        let profileVC = makeChildViewController(rootViewController: ProfileViewController(), prefersLargeTitles: false, title: "Profile", image: Images.profileUnselected, selectedImage: Images.profile)
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
    
    func makeChildViewController(rootViewController: UIViewController, prefersLargeTitles: Bool, title: String?, image: UIImage?, selectedImage: UIImage?) -> UIViewController {
            // Add BaseNavigationController
            let nav = BaseNavigationController(rootViewController: rootViewController, prefersLargeTitles: prefersLargeTitles)
            // Add bar item
    //        let tabBarItem = RAMAnimatedTabBarItem(title: title, image: image, selectedImage: selectedImage)
    //        tabBarItem.animation = RAMBounceAnimation()
            let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
            nav.tabBarItem = tabBarItem
            return nav
        }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            #warning("TODO: Error popup")
            print(error.localizedDescription)
            return
        }
        guard let auth = user.authentication else {
            #warning("TODO: Error popup")
            print(error.localizedDescription)
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                #warning("TODO: Error popup")
                print(error.localizedDescription)
                return
            }
            // Shouldn't need to do anything here due to the Auth state listener set previously.
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = (GIDSignIn.sharedInstance()?.handle(url))! || ApplicationDelegate.shared.application(app, open: url, options: options)
        return handled
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
