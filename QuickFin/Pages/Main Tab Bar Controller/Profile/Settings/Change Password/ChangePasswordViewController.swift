//
//  ChangePasswordViewController.swift
//  QuickFin
//
//  Created by Boyuan Xu on 10/11/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Localize_Swift
import ReactiveKit

class ChangePasswordViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    func changePassword(password: String) {
        #warning("TODO: Change password logic")
    }
}

// MARK: - UI
extension ChangePasswordViewController {
    
    func initUI() {
        title = "Change Password".localized()
        
        let oldPasswordTextField = makeTextField(title: "Old password")
        let newPasswordTextField = makeTextField(title: "New password")
        let confirmNewPasswordTextField = makeTextField(title: "Confirm new password")
        _ = confirmNewPasswordTextField.reactive.text.observeNext { (text) in
            if text != newPasswordTextField.text {
                confirmNewPasswordTextField.errorMessage = "New passwords don't match!".localized()
            } else {
                confirmNewPasswordTextField.errorMessage = nil
            }
        }
        let changePasswordButton: UIButton = {
            let b = UIButton()
            b.setTitle("Change Password".localized(), for: .normal)
            b.setTitleColor(UIColor.white, for: .normal)
            b.backgroundColor = Colors.FidelityGreen!
            b.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            _ = b.reactive.tap.observeNext { [unowned self] (_) in
                if let password = confirmNewPasswordTextField.text {
                    self.changePassword(password: password)
                } else {
                    #warning("TODO: Error popup: No password entered")
                }
            }
            return b
        }()
        
        view.addSubview(oldPasswordTextField)
        oldPasswordTextField.snp.makeConstraints { (this) in
            this.top.equalTo(view.snp_topMargin).offset(20)
            this.leading.equalToSuperview().offset(20)
            this.trailing.equalToSuperview().offset(-20)
        }
        view.addSubview(newPasswordTextField)
        newPasswordTextField.snp.makeConstraints { (this) in
            this.top.equalTo(oldPasswordTextField.snp.bottom).offset(10)
            this.leading.equalTo(oldPasswordTextField.snp.leading)
            this.trailing.equalTo(oldPasswordTextField.snp.trailing)
        }
        view.addSubview(confirmNewPasswordTextField)
        confirmNewPasswordTextField.snp.makeConstraints { (this) in
            this.top.equalTo(newPasswordTextField.snp.bottom).offset(10)
            this.leading.equalTo(oldPasswordTextField.snp.leading)
            this.trailing.equalTo(oldPasswordTextField.snp.trailing)
        }
        view.addSubview(changePasswordButton)
        changePasswordButton.snp.makeConstraints { (this) in
            this.top.equalTo(confirmNewPasswordTextField.snp.bottom).offset(20)
            this.centerX.equalToSuperview()
        }
        changePasswordButton.layer.cornerRadius = 2
    }
    
    private func makeTextField(title: String) -> SkyFloatingLabelTextField {
        let tf = SkyFloatingLabelTextField()
        tf.title = title.localized()
        tf.placeholder = title.localized()
        tf.errorColor = UIColor.red
        tf.textColor = Colors.DynamicTextColor
        tf.selectedTitleColor = Colors.FidelityGreen!
        tf.selectedLineColor = Colors.FidelityGreen!
        tf.isSecureTextEntry = true
        return tf
    }
    
}
