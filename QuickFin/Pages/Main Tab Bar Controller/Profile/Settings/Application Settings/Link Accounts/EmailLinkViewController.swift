//
//  EmailLinkViewController.swift
//  QuickFin
//
//  Created by Boyuan Xu on 11/15/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import SnapKit
import Bond
import FirebaseAuth

class EmailLinkViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
}

extension EmailLinkViewController {
    
    func initUI() {
        title = "Link Email".localized()
        
        let vStack: UIStackView = {
            let v = UIStackView()
            v.axis = .vertical
            v.spacing = 10
            v.distribution = .fillProportionally
            return v
        }()
        let emailTextField = makeTextField(title: "Email", isSecure: false)
        let passwordTextField = makeTextField(title: "Password", isSecure: true)
        let linkEmailButton: UIButton = {
            let b = UIButton()
            b.setTitle("Link Email".localized(), for: .normal)
            b.setTitleColor(UIColor.white, for: .normal)
            b.backgroundColor = Colors.FidelityGreen!
            b.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            _ = b.reactive.tap.observeNext { (_) in
                if emailTextField.text?.isEmpty ?? false || passwordTextField.text?.isEmpty ?? false {
                    MessageHandler.shared.showMessageModal(theme: .error, title: Text.Error, body: "Please complete the fields.".localized())
                    return
                }
                let credential = EmailAuthProvider.credential(withEmail: emailTextField.text!, password: passwordTextField.text!)
                Auth.auth().currentUser?.link(with: credential, completion: { (result, error) in
                    if let error = error {
                        MessageHandler.shared.showMessageModal(theme: .error, title: Text.Error, body: error.localizedDescription)
                        return
                    }
                    MessageHandler.shared.showMessageModal(theme: .success, title: "Success".localized(), body: "Accounts linked.".localized())
                })
            }
            return b
        }()
        
        vStack.addArrangedSubview(emailTextField)
        vStack.addArrangedSubview(passwordTextField)
        vStack.addArrangedSubview(linkEmailButton)
        vStack.setCustomSpacing(20, after: passwordTextField)
        view.addSubview(vStack)
        vStack.snp.makeConstraints { (this) in
            this.top.equalTo(view.snp.topMargin).offset(20)
            this.leading.equalToSuperview().offset(20)
            this.trailing.equalToSuperview().offset(-20)
            this.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
        linkEmailButton.layer.cornerRadius = 2
    }
}
