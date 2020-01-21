//
//  ChangeUsernameViewController.swift
//  QuickFin
//
//  Created by Boyuan Xu on 11/15/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import Bond
import SnapKit

class ChangeUsernameViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }

}

// MARK: - UI
extension ChangeUsernameViewController {
    
    func initUI() {
        title = "Change Username".localized()
        
        let vStack: UIStackView = {
            let v = UIStackView()
            v.axis = .vertical
            v.spacing = 10
            v.distribution = .fillProportionally
            return v
        }()
        let newUsernameTextField = makeTextField(title: "New Username".localized(), isSecure: false)
        let changeUsernameButton: UIButton = {
            let b = UIButton()
            b.setTitle("Change Username".localized(), for: .normal)
            b.setTitleColor(UIColor.white, for: .normal)
            b.backgroundColor = Colors.FidelityGreen!
            b.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            _ = b.reactive.tap.observeNext { (_) in
                if newUsernameTextField.text?.isEmpty ?? true {
                    MessageHandler.shared.showMessage(theme: .error, title: Text.Error, body: "Please complete the fields.".localized())
                }
                if let newUsername = newUsernameTextField.text {
                    #warning("TODO: Change username in Firebase")
                }
            }
            return b
        }()
        
        vStack.addArrangedSubview(newUsernameTextField)
        vStack.addArrangedSubview(changeUsernameButton)
        view.addSubview(vStack)
        vStack.snp.makeConstraints { (this) in
            this.top.equalTo(view.snp.topMargin).offset(20)
            this.leading.equalToSuperview().offset(20)
            this.trailing.equalToSuperview().offset(-20)
            this.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
        changeUsernameButton.layer.cornerRadius = 2
    }
}
