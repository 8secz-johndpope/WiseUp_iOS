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
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    var profileImageView: UIImageView!
    var coinBalanceLabel: UILabel!
    var achievementLabel: UILabel!
    var xpProgressBarBackgroundView: UIView!
    var xpProgressBarFiller: UIView!
    var tableView: UITableView!
    let cellReuseID = "profileSettings"
    let profileSettings = [
        "Change Avatar".localized(),
        "Items".localized(),
        "Settings".localized()
    ]
    let profileSettingIcons: [UIImage] = [#imageLiteral(resourceName: "Change Avatar"), #imageLiteral(resourceName: "Consumables"), #imageLiteral(resourceName: "Settings")]
    
    func fetchData() {
        let xpPercentage = (Double)(UserShared.shared.experience % 1000) / 1000.0
        coinBalanceLabel.text = UserShared.shared.coins.description
        achievementLabel.text = UserShared.shared.achievementCount.description
        UIView.animate(withDuration: 0.4) {
            self.xpProgressBarFiller.snp.remakeConstraints { (this) in
                this.leading.equalTo(self.xpProgressBarBackgroundView.snp.leading)
                this.height.equalTo(10)
                this.centerY.equalTo(self.xpProgressBarBackgroundView.snp.centerY)
                this.width.equalTo(self.xpProgressBarBackgroundView.snp.width).multipliedBy(xpPercentage)
            }
            self.xpProgressBarFiller.superview?.layoutIfNeeded()
        }
        updateProfileImage()
    }
    
    func openSettings() {
        let settingsVC = BaseNavigationController(rootViewController: SettingsViewController(), prefersLargeTitles: false)
        present(settingsVC, animated: true, completion: nil)
    }
    
    func openChangeAvatar() {
        let avatarVC = ChangeAvatarViewController(collectionViewLayout: UICollectionViewFlowLayout())
        avatarVC.delegate = self
        let wrappedAvatarVC = BaseNavigationController(rootViewController: avatarVC, prefersLargeTitles: false)
        present(wrappedAvatarVC, animated: true)
    }
    
    func openItems() {
        let itemsVC = BaseNavigationController(rootViewController: ItemsViewController(), prefersLargeTitles: false)
        present(itemsVC, animated: true, completion: nil)
    }
    
    func updateProfileImage() {
        profileImageView.image = UIImage(named: UserShared.shared.avatar)
    }
}

