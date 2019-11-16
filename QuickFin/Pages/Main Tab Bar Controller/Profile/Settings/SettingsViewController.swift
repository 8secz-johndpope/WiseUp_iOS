//
//  SettingsViewController.swift
//  QuickFin
//
//  Created by Boyuan Xu on 10/11/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import Localize_Swift

class SettingsViewController: BaseViewController {

    var tableView: UITableView!
    let cellReuseID = "settings";
    let settingsMenu = ["Change Password".localized(),
                        "Application Settings".localized(),
                        "Privacy Notice".localized(),
                        "About".localized(),
                        "Log Out".localized()
    ]
    let settingsMenuIcons: [UIImage] = [#imageLiteral(resourceName: "Change Password"), #imageLiteral(resourceName: "Settings"), #imageLiteral(resourceName: "Privacy Notice"), #imageLiteral(resourceName: "Notice"), #imageLiteral(resourceName: "Logout")]
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initTableView()
    }

}
