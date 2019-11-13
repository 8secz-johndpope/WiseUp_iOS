//
//  SignUpViewController.swift
//  QuickFin
//
//  Created by Boyuan Xu on 11/12/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import SnapKit
import Bond
import SkyFloatingLabelTextField
import FirebaseAuth

class SignUpViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    func signUpHandler(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                ErrorMessageHandler.shared.showMessage(theme: .error, title: "Sign up error", body: error.localizedDescription)
                return
            }
        }
    }

}

// MARK: - UI
extension SignUpViewController {
    
    func initUI() {
        let stackView: UIStackView = {
            let v = UIStackView()
            v.axis = .vertical
            v.distribution = .fillEqually
            v.spacing = 10
            return v
        }()
        let emailField: SkyFloatingLabelTextField = {
            let tf = SkyFloatingLabelTextField()
            tf.title = "Email".localized()
            tf.placeholder = "Email".localized()
            tf.textColor = Colors.DynamicTextColor
            tf.selectedTitleColor = Colors.FidelityGreen!
            tf.selectedLineColor = Colors.FidelityGreen!
            tf.autocapitalizationType = .none
            tf.autocorrectionType = .no
            tf.spellCheckingType = .no
            return tf
        }()
        let passwordField: SkyFloatingLabelTextField = {
            let tf = SkyFloatingLabelTextField()
            tf.title = "Password".localized()
            tf.placeholder = "Password".localized()
            tf.textColor = Colors.DynamicTextColor
            tf.selectedTitleColor = Colors.FidelityGreen!
            tf.selectedLineColor = Colors.FidelityGreen!
            tf.isSecureTextEntry = true
            return tf
        }()
        let confirmPasswordField: SkyFloatingLabelTextField = {
            let tf = SkyFloatingLabelTextField()
            tf.title = "Confirm Password".localized()
            tf.placeholder = "Confirm Password".localized()
            tf.textColor = Colors.DynamicTextColor
            tf.selectedTitleColor = Colors.FidelityGreen!
            tf.selectedLineColor = Colors.FidelityGreen!
            tf.isSecureTextEntry = true
            return tf
        }()
        let signUpButton: UIButton = {
            let b = UIButton()
            b.setTitle("Sign Up".localized(), for: .normal)
            b.setTitleColor(UIColor.white, for: .normal)
            b.backgroundColor = Colors.FidelityGreen!
            _ = b.reactive.tap.observeNext { [unowned self] (_) in
                if let email = emailField.text, let password = passwordField.text, let confirmPassword = confirmPasswordField.text {
                    if password != confirmPassword {
                        ErrorMessageHandler.shared.showMessage(theme: .error, title: "Sign up error", body: "Passwords don't match.".localized())
                        return
                    }
                    self.signUpHandler(email: email, password: password)
                }
            }
            return b
        }()
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(confirmPasswordField)
        stackView.addArrangedSubview(signUpButton)
        view.addSubview(stackView)
        stackView.snp.makeConstraints { (this) in
            this.center.equalToSuperview()
            this.width.equalToSuperview().offset(-40)
        }
        signUpButton.layer.cornerRadius = 2
    }
}
