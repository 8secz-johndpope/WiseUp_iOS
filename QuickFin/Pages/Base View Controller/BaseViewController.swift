//
//  BaseViewController.swift
//  QuickFin
//
//  Created by Boyuan Xu on 9/21/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
    }
}

extension UIViewController {
    
    func setBackground() {
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
        } else {
            view.backgroundColor = UIColor.white
        }
    }
    
}
