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
        
        let profileNameView: UITextView = {
            let textView = UITextView()
            textView.text = "Director Jeff".localized()
            textView.font = .boldSystemFont(ofSize: 40)
            return textView
        }()
                
        
        let coinsImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.image = UIImage(named: "Coins")
            return imageView
        }()
        
        let coinsNameView: UITextView = {
            let textView = UITextView()
            textView.text = "48".localized()
            textView.font = .systemFont(ofSize: 28)
            textView.textColor = UIColor.brown
            return textView
          }()
        
        
        let rankImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.image = UIImage(named: "Rank")
            return imageView
        }()
        
        let rankNameView: UITextView = {
              let textView = UITextView()
              textView.text = "11".localized()
              textView.font = .systemFont(ofSize: 28)
            textView.textColor = UIColor.brown
              return textView
          }()
        
        
        let xpImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.image = UIImage(named: "XP")
            return imageView
        }()
        
        let xpNameView: UITextView = {
             let textView = UITextView()
              textView.text = "400/1000".localized()
              textView.font = .systemFont(ofSize: 28)
              textView.textColor = UIColor.brown
              return textView
          }()
        
        
        profileImageView.frame = CGRect(x: 30, y: 130, width: 80, height: 80)
        profileNameView.frame = CGRect(x: 120, y: 130, width: 300, height: 80)
        coinsImageView.frame = CGRect(x: 50, y: 220, width: 40, height: 40)
        coinsNameView.frame = CGRect(x: 100, y: 215, width: 300, height: 40)
        rankImageView.frame = CGRect(x: 50, y: 275, width: 40, height: 40)
        rankNameView.frame = CGRect(x: 100, y: 265, width: 300, height: 40)
        xpImageView.frame = CGRect(x: 60, y: 330, width: 25, height: 25)
        xpNameView.frame = CGRect(x: 100, y: 315, width: 300, height: 40)
        view.addSubview(profileNameView)
        view.addSubview(profileImageView)
        view.addSubview(coinsImageView)
        view.addSubview(coinsNameView)
        view.addSubview(rankImageView)
        view.addSubview(rankNameView)
        view.addSubview(xpImageView)
        view.addSubview(xpNameView)
      
    }
    
//    func initUI() {
//
//        // MARK: - Sign in section
//        let signOutView: UIStackView = {
//            let v = UIStackView()
//            v.axis = .vertical
//            v.alignment = .center
//            v.spacing = 5
//            return v
//        }()
//
//        let signOutButton: UIButton = {
//            let b = UIButton()
//            b.setTitle("Sign Out".localized(), for: .normal)
//            b.setTitleColor(UIColor.white, for: .normal)
//            b.backgroundColor = Colors.FidelityGreen
//            b.reactive.tap.observeNext { [unowned self] (_) in
//                do {
//                    try Auth.auth().signOut()
//                } catch let error as NSError {
//                    #warning("TODO: Error popup")
//                    print(error.localizedDescription)
//                }
//            }
//            return b
//        }()
//
//        signOutView.addArrangedSubview(signOutButton)
//
//        view.addSubview(signOutView)
//        signOutView.snp.makeConstraints { (this) in
//            this.center.equalToSuperview()
//            this.leading.equalTo(view.snp.leadingMargin)
//            this.trailing.equalTo(view.snp.trailingMargin)
//        }
     
        
//    }
        
}
