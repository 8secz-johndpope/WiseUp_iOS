//
//  ProfileViewController.swift
//  QuickFin
//
//  Created by Connor Buckley on 9/22/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import SnapKit

class ProfileViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Profile".localized()
        setBackground()
        initNavBar()
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //initUI()
        fetchData()
    }
    
    var profileImageView: UIImageView!
    var xpProgressBarBackgroundView: UIView!
    var xpProgressBarFiller: UIView!
    var tableView: UITableView!
    let cellReuseID = "profileSettings"
    let profileSettings = [
        "Change avatar".localized(),
        "Consumables".localized(),
        "Profile settings".localized()
    ]
    let profileSettingIcons: [UIImage] = [#imageLiteral(resourceName: "Change Avatar"), #imageLiteral(resourceName: "Consumables"), #imageLiteral(resourceName: "Settings")]
    
    func fetchData() {
        let xpPercentage = (Double)(User.shared.experience % 1000) / 1000.0
        UIView.animate(withDuration: 0.4) {
            self.xpProgressBarFiller.snp.remakeConstraints { (this) in
                this.leading.equalTo(self.xpProgressBarBackgroundView.snp.leading)
                this.height.equalTo(10)
                this.centerY.equalTo(self.xpProgressBarBackgroundView.snp.centerY)
                this.width.equalTo(self.xpProgressBarBackgroundView.snp.width).multipliedBy(xpPercentage)
            }
            self.xpProgressBarFiller.superview?.layoutIfNeeded()
        }
    }
}

