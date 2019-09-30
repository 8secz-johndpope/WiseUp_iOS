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
    
}

extension BaseNavigationController {
    
    func initBaseUI() {
        navigationBar.barTintColor = Colors.DynamicNavigationBarColor
        navigationBar.tintColor = Colors.DynamicNavigationTitleColor
        let titleAttributes = [NSAttributedString.Key.foregroundColor: Colors.DynamicNavigationTitleColor!]
        navigationBar.titleTextAttributes = titleAttributes
    }
    
}
