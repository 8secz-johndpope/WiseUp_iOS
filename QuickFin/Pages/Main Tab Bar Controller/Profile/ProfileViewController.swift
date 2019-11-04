//
//  ProfileViewController.swift
//  QuickFin
//
//  Created by Connor Buckley on 9/22/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Profile".localized()
        setBackground()
        initNavBar()
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initUI()
    }
}

