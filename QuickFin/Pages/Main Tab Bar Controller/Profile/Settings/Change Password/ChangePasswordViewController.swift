//
//  ChangePasswordViewController.swift
//  QuickFin
//
//  Created by Boyuan Xu on 10/11/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import ReactiveKit
import Firebase

class ChangePasswordViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    func changePassword(email: String, currentPassword: String, newPassword: String) {
        let credentials = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        Auth.auth().currentUser?.reauthenticate(with: credentials, completion: { (result, error) in
            if let error = error {
                ErrorMessageHandler.shared.showMessageModal(theme: .error, title: "Update password error".localized(), body: error.localizedDescription + " " + "You will be logged out.".localized())
                try? Auth.auth().signOut()
                return
            }
            Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { (error) in
                if let error = error {
                    ErrorMessageHandler.shared.showMessageModal(theme: .error, title: "Update password error", body: error.localizedDescription)
                }
            })
        })
    }
}

// MARK: - UI
extension ChangePasswordViewController {
    
    func initUI() {
        title = "Change Password".localized()
        
        let vStack: UIStackView = {
            let v = UIStackView()
            v.axis = .vertical
            v.spacing = 10
            v.distribution = .fillProportionally
            return v
        }()
        let emailTextField = makeTextField(title: "Email", isSecure: false)
        let currentPasswordTextField = makeTextField(title: "Current password", isSecure: true)
        let newPasswordTextField = makeTextField(title: "New password", isSecure: true)
        let confirmNewPasswordTextField = makeTextField(title: "Confirm new password", isSecure: true)
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
                if emailTextField.text?.isEmpty ?? false || currentPasswordTextField.text?.isEmpty ?? false || newPasswordTextField.text?.isEmpty ?? false {
                    ErrorMessageHandler.shared.showMessageModal(theme: .error, title: "Update password error".localized(), body: "Please complete the fields.".localized())
                    return
                }
                if newPasswordTextField.text != confirmNewPasswordTextField.text {
                    ErrorMessageHandler.shared.showMessageModal(theme: .error, title: "Update password error".localized(), body: "Passwords do not match!".localized())
                    return
                }
                if newPasswordTextField.text?.count ?? 0 < 6 {
                    ErrorMessageHandler.shared.showMessageModal(theme: .error, title: "Update password error".localized(), body: "New password must be longer than 6 characters.".localized())
                    return
                }
                if let email = emailTextField.text, let currentPassword = currentPasswordTextField.text, let newPassword = confirmNewPasswordTextField.text {
                    self.changePassword(email: email, currentPassword: currentPassword, newPassword: newPassword)
                }
            }
            return b
        }()
        
        vStack.addArrangedSubview(emailTextField)
        vStack.addArrangedSubview(currentPasswordTextField)
        vStack.addArrangedSubview(newPasswordTextField)
        vStack.addArrangedSubview(confirmNewPasswordTextField)
        vStack.addArrangedSubview(changePasswordButton)
        vStack.setCustomSpacing(20, after: confirmNewPasswordTextField)
        view.addSubview(vStack)
        vStack.snp.makeConstraints { (this) in
            this.top.equalTo(view.snp.topMargin).offset(20)
            this.leading.equalToSuperview().offset(20)
            this.trailing.equalToSuperview().offset(-20)
            this.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
        changePasswordButton.layer.cornerRadius = 2
    }
    
}

