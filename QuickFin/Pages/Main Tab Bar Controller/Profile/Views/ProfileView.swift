//
//  ProfileView.swift
//  QuickFin
//
//  Created by Connor Buckley on 9/22/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension ProfileViewController {


    func initUI() {
        
        // MARK: - Sign in section
        let signOutView: UIStackView = {
            let v = UIStackView()
            v.axis = .vertical
            v.alignment = .center
            v.spacing = 5
            return v
        }()

        let signOutButton: UIButton = {
            let b = UIButton()
            b.setTitle("Sign Out".localized(), for: .normal)
            b.setTitleColor(UIColor.white, for: .normal)
            b.backgroundColor = Colors.FidelityGreen
            b.reactive.tap.observeNext { [unowned self] (_) in
                do {
                    try Auth.auth().signOut()
                } catch let error as NSError {
                    #warning("TODO: Error popup")
                    print(error.localizedDescription)
                }
            }
            return b
        }()
        
        signOutView.addArrangedSubview(signOutButton)

        view.addSubview(signOutView)
        signOutView.snp.makeConstraints { (this) in
            this.center.equalToSuperview()
            this.leading.equalTo(view.snp.leadingMargin)
            this.trailing.equalTo(view.snp.trailingMargin)
        }
     
        
    }
        
}