//
//  ChangePasswordViewController.swift
//  QuickFin
//
//  Created by Boyuan Xu on 10/11/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import ReactiveKit
import Firebase

class ChangePasswordViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    func changePassword(password: String) {
        #warning("TODO: Reauthenticate before password change!")
        Auth.auth().currentUser?.updatePassword(to: password, completion: { (error) in
            if let error = error {
                ErrorMessageHandler.shared.showMessageModal(theme: .error, title: "Update password error", body: error.localizedDescription)
            }
        })
    }
}

// MARK: - UI
extension ChangePasswordViewController {
    
    func initUI() {
        title = "Change Password".localized()
        
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
                if newPasswordTextField.text != confirmNewPasswordTextField.text {
                    ErrorMessageHandler.shared.showMessage(theme: .error, title: "Update password error", body: "Passwords do not match!".localized())
                }
                if let password = confirmNewPasswordTextField.text {
                    self.changePassword(password: password)
                }
            }
            return b
        }()
        
        view.addSubview(newPasswordTextField)
        newPasswordTextField.snp.makeConstraints { (this) in
            this.top.equalTo(view.snp_topMargin).offset(20)
            this.leading.equalToSuperview().offset(20)
            this.trailing.equalToSuperview().offset(-20)
        }
        view.addSubview(confirmNewPasswordTextField)
        confirmNewPasswordTextField.snp.makeConstraints { (this) in
            this.top.equalTo(newPasswordTextField.snp.bottom).offset(10)
            this.leading.equalTo(newPasswordTextField.snp.leading)
            this.trailing.equalTo(newPasswordTextField.snp.trailing)
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
