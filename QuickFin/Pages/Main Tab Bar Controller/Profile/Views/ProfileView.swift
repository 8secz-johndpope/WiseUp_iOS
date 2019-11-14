//
//  ProfileView.swift
//  QuickFin
//
//  Created by Connor Buckley on 9/22/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import SnapKit

extension ProfileViewController {
    
    func initNavBar() {
        let settingsItem = UIBarButtonItem(image: "🛠".emojiToImage(), style: .plain, target: self, action: #selector(openSettings))
        navigationItem.setRightBarButton(settingsItem, animated: true)
    }
    
    @objc func openSettings() {
        let settingsVC = BaseNavigationController(rootViewController: SettingsViewController(), prefersLargeTitles: false)
        present(settingsVC, animated: true, completion: nil)
    }
        
    func initUI() {
                
        let profileImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.image = UIImage(named: "Profile Image")
            return imageView
        }()
        let profileNameLabel: UILabel = {
            let l = UILabel()
            if UserShared.shared.getName() == " " {
                l.text = UserShared.shared.displayName
            } else {
                l.text = UserShared.shared.getName()
            }
            l.font = .boldSystemFont(ofSize: FontSizes.largeNavTitle)
            l.textColor = Colors.DynamicTextColor
            return l
        }()
        
        let horizontalStackView: UIStackView = {
            let v = UIStackView()
            v.axis = .horizontal
            v.distribution = .fillEqually
            v.alignment = .center
            return v
        }()
        
        let coinContainerView = UIView()
        let coinBalanceNameLabel: UILabel = {
            let l = UILabel()
            l.text = "Coins".localized()
            l.font = .boldSystemFont(ofSize: FontSizes.pageTitle)
            l.textColor = Colors.DynamicTextColor
            return l
        }()
        coinBalanceLabel = {
            let l = UILabel()
            l.text = UserShared.shared.coins.description
            l.font = .systemFont(ofSize: FontSizes.pageTitle)
            l.textColor = Colors.DynamicTextColor
            return l
        }()
    
        let achievementContainerView = UIView()
        let achievementNameLabel: UILabel = {
            let l = UILabel()
            l.text = "Achievements".localized()
            l.font = .boldSystemFont(ofSize: FontSizes.pageTitle)
            l.textColor = Colors.DynamicTextColor
            return l
        }()
        achievementLabel = {
            let l = UILabel()
            l.text = UserShared.shared.achievementCount.description
            l.font = .systemFont(ofSize: FontSizes.pageTitle)
            l.textColor = Colors.DynamicTextColor
            return l
        }()
        
        let xpImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.image = UIImage(named: "XP")
            return imageView
        }()
        xpProgressBarBackgroundView = UIView()
        xpProgressBarFiller = UIView()
        xpProgressBarFiller.backgroundColor = Colors.FidelityGreen
        
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { (this) in
            this.top.equalTo(view.snp.topMargin).offset(20)
            this.centerX.equalToSuperview()
            this.width.equalTo(150)
            this.height.equalTo(150)
        }
        view.addSubview(profileNameLabel)
        profileNameLabel.snp.makeConstraints { (this) in
            this.top.equalTo(profileImageView.snp.bottom)
            this.centerX.equalToSuperview()
        }
        profileImageView.layer.shadowColor = Colors.DynamicTextColor?.cgColor
        profileImageView.layer.shadowOpacity = 0.3
        profileImageView.layer.shadowRadius = 5
        profileImageView.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        view.addSubview(xpImageView)
        xpImageView.snp.makeConstraints { (this) in
            this.top.equalTo(profileNameLabel.snp.bottom).offset(10)
            this.leading.equalToSuperview().offset(20)
        }
        view.addSubview(xpProgressBarBackgroundView)
        xpProgressBarBackgroundView.snp.makeConstraints { (this) in
            this.leading.equalTo(xpImageView.snp.trailing).offset(10)
            this.trailing.equalToSuperview().offset(-20)
            this.height.equalTo(10)
            this.centerY.equalTo(xpImageView.snp.centerY)
        }
        view.addSubview(xpProgressBarFiller)
        xpProgressBarFiller.snp.makeConstraints { (this) in
            this.leading.equalTo(xpProgressBarBackgroundView.snp.leading)
            this.height.equalTo(10)
            this.centerY.equalTo(xpProgressBarBackgroundView.snp.centerY)
            this.width.equalTo(xpProgressBarBackgroundView.snp.width).multipliedBy(1)
        }
        xpProgressBarBackgroundView.layer.borderColor = Colors.DynamicTextColor?.cgColor
        xpProgressBarBackgroundView.layer.borderWidth = 0.3
        xpProgressBarBackgroundView.layer.cornerRadius = 5
        xpProgressBarFiller.layer.cornerRadius = 5
        xpProgressBarFiller.layer.shadowColor = Colors.FidelityGreen?.cgColor
        xpProgressBarFiller.layer.shadowOpacity = 0.7
        xpProgressBarFiller.layer.shadowRadius = 7
        xpProgressBarFiller.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        coinContainerView.addSubview(coinBalanceNameLabel)
        coinBalanceNameLabel.snp.makeConstraints { (this) in
            this.top.equalToSuperview()
            this.centerX.equalToSuperview()
        }
        coinContainerView.addSubview(coinBalanceLabel)
        coinBalanceLabel.snp.makeConstraints { (this) in
            this.top.equalTo(coinBalanceNameLabel.snp.bottom)
            this.centerX.equalToSuperview()
        }
        achievementContainerView.addSubview(achievementNameLabel)
        achievementNameLabel.snp.makeConstraints { (this) in
            this.top.equalToSuperview()
            this.centerX.equalToSuperview()
        }
        achievementContainerView.addSubview(achievementLabel)
        achievementLabel.snp.makeConstraints { (this) in
            this.top.equalTo(achievementNameLabel.snp.bottom)
            this.centerX.equalToSuperview()
        }
        horizontalStackView.addArrangedSubview(coinContainerView)
        horizontalStackView.addArrangedSubview(achievementContainerView)
        view.addSubview(horizontalStackView)
        horizontalStackView.snp.makeConstraints { (this) in
            this.top.equalTo(xpImageView.snp.bottom).offset(20)
            this.leading.equalToSuperview()
            this.trailing.equalToSuperview()
        }
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: cellReuseID)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (this) in
            this.top.equalTo(horizontalStackView.snp.bottom).offset(50)
            this.leading.equalToSuperview()
            this.trailing.equalToSuperview()
            this.bottomMargin.equalToSuperview()
        }
        print("Height: \(horizontalStackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize))")
    }
}

// MARK: - UITableView
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID, for: indexPath) as! SettingsTableViewCell;
        cell.titleLabel.text = profileSettings[indexPath.row]
        return cell
    }
    
}
