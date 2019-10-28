//
//  BaseNavigationController.swift
//  QuickFin
//
//  Created by Boyuan Xu on 9/28/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBaseUI()
    }
    
    init(rootViewController: UIViewController, prefersLargeTitles: Bool) {
        super.init(rootViewController: rootViewController)
        navigationBar.prefersLargeTitles = prefersLargeTitles
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let appearance: UINavigationBarAppearance = {
        let titleAttributes = [NSAttributedString.Key.foregroundColor: Colors.DynamicNavigationTitleColor!]
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.largeTitleTextAttributes = titleAttributes
        appearance.titleTextAttributes = titleAttributes
        appearance.backgroundColor = Colors.DynamicNavigationBarColor
        return appearance
    }()
    
    
}

extension BaseNavigationController {
    
    func initBaseUI() {
        navigationBar.tintColor = Colors.DynamicNavigationTitleColor
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationBar.layer.shadowOpacity = 0.15
        navigationBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        navigationBar.layer.masksToBounds = false
    }
    
}
