//
//  ForgotPasswordViewController.swift
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

class ForgotPasswordViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    func resetPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                MessageHandler.shared.showMessage(theme: .error, title: "Reset Password".localized(), body: error.localizedDescription)
                return
            }
        }
    }

}

// MARK: - UI
extension ForgotPasswordViewController {
    
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
        let resetPasswordButton: UIButton = {
            let b = UIButton()
            b.setTitle("Reset Password".localized(), for: .normal)
            b.setTitleColor(UIColor.white, for: .normal)
            b.backgroundColor = Colors.FidelityGreen!
            _ = b.reactive.tap.observeNext { [unowned self] (_) in
                if let email = emailField.text {
                    self.resetPassword(email: email)
                }
            }
            return b
        }()
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(resetPasswordButton)
        view.addSubview(stackView)
        stackView.snp.makeConstraints { (this) in
            this.center.equalToSuperview()
            this.width.equalToSuperview().offset(-40)
        }
        resetPasswordButton.layer.cornerRadius = 2
    }
}
