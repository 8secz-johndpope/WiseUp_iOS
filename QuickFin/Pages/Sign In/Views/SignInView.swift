//
//  SignInView.swift
//  QuickFin
//
//  Created by Boyuan Xu on 9/21/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import SnapKit
import SkyFloatingLabelTextField
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import Bond

extension SignInViewController {
    
    func initUI() {
        let logo = #imageLiteral(resourceName: "Quick Fin Logo")
        
        // MARK: - QuickFin title & logo
        let titleView = UIView()
        let logoImageView = UIImageView(image: logo)
        let quickFinTitleLabel: UILabel = {
            let l = UILabel()
            l.text = "QuickFin:".localized()
            l.font = UIFont.systemFont(ofSize: FontSizes.largeNavTitle, weight: .bold)
            return l
        }()
        let quickFinSubtitleLabel: UILabel = {
            let l = UILabel()
            l.text = "A financial literacy game.".localized()
            l.font = UIFont.systemFont(ofSize: FontSizes.pageTitle, weight: .regular)
            return l
        }()
        
        titleView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { (this) in
            this.top.equalToSuperview()
            this.leading.equalToSuperview()
        }
        titleView.addSubview(quickFinTitleLabel)
        quickFinTitleLabel.snp.makeConstraints { (this) in
            this.top.equalTo(logoImageView.snp.bottom)
            this.leading.equalTo(logoImageView.snp.leading)
        }
        titleView.addSubview(quickFinSubtitleLabel)
        quickFinSubtitleLabel.snp.makeConstraints { (this) in
            this.top.equalTo(quickFinTitleLabel.snp.bottom)
            this.leading.equalTo(quickFinTitleLabel.snp.leading)
        }
        
        view.addSubview(titleView)
        titleView.snp.makeConstraints { (this) in
            this.top.equalTo(view.snp.topMargin).offset(10)
            this.leading.equalTo(view.snp.leadingMargin)
        }
        
        // MARK: - Sign in section
        let signInView: UIStackView = {
            let v = UIStackView()
            v.axis = .vertical
            v.alignment = .center
            v.spacing = 5
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
        let passwordStackView: UIStackView = {
            let v = UIStackView()
            v.axis = .horizontal
            v.alignment = .center
            v.spacing = 5
            return v
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
        let revealPasswordButton: UIButton = {
            let b = UIButton()
            b.setTitle("Toggle".localized(), for: .normal)
            b.setTitleColor(UIColor.white, for: .normal)
            b.titleLabel?.font = UIFont.systemFont(ofSize: FontSizes.text)
            b.contentEdgeInsets = UIEdgeInsets(top: 5, left: 6, bottom: 5, right: 6)
            _ = b.reactive.tap.observeNext { (_) in
                passwordField.isSecureTextEntry.toggle()
            }
            return b
        }()
        let signInButton: UIButton = {
            let b = UIButton()
            b.setTitle("Sign In".localized(), for: .normal)
            b.setTitleColor(UIColor.white, for: .normal)
            b.backgroundColor = Colors.FidelityGreen!
            _ = b.reactive.tap.observeNext { [unowned self] (_) in
                self.emailSignInHandler(email: emailField.text, password: passwordField.text)
            }
            return b
        }()
        let googleSignInButton: GIDSignInButton = {
            let b = GIDSignInButton()
            b.style = .wide
            if traitCollection.userInterfaceStyle == .light {
                b.colorScheme = .light
            } else {
                b.colorScheme = .dark
            }
            return b
        }()
        let facebookSignInButton: FBLoginButton = {
            let b = FBLoginButton()
            b.delegate = self
            return b
        }()
        
        signInView.addArrangedSubview(emailField)
        emailField.snp.makeConstraints { (this) in
            this.width.equalTo(signInView.snp.width).offset(-40)
            this.height.equalTo(40)
        }
        signInView.addArrangedSubview(passwordStackView)
        passwordStackView.addArrangedSubview(passwordField)
        passwordStackView.addArrangedSubview(revealPasswordButton)
        revealPasswordButton.layer.backgroundColor = Colors.FidelityGreen?.cgColor
        revealPasswordButton.layer.cornerRadius = 2
        
        passwordStackView.snp.makeConstraints { (this) in
            this.width.equalTo(emailField.snp.width)
            this.height.equalTo(emailField.snp.height)
        }
        signInView.addArrangedSubview(signInButton)
        signInView.addArrangedSubview(googleSignInButton)
        signInView.addArrangedSubview(facebookSignInButton)
        signInButton.snp.makeConstraints { (this) in
            this.height.equalTo(googleSignInButton.snp.height).offset(-10)
            this.width.equalTo(googleSignInButton.snp.width).offset(-8)
        }
        signInButton.layer.cornerRadius = 2

        view.addSubview(signInView)
        signInView.snp.makeConstraints { (this) in
            this.center.equalToSuperview()
            this.leading.equalTo(view.snp.leadingMargin)
            this.trailing.equalTo(view.snp.trailingMargin)
        }
        signInView.setCustomSpacing(20, after: passwordStackView)
        
        // MARK: - Sign up & forgot password
        let bottomView: UIStackView = {
            let v = UIStackView()
            v.axis = .vertical
            v.alignment = .center
            return v
        }()
        let signUpButton: UIButton = {
            let b = UIButton()
            b.setTitle("Sign Up".localized(), for: .normal)
            b.setTitleColor(Colors.FidelityGreen, for: .normal)
            _ = b.reactive.tap.observeNext { [weak self] (_) in
                self?.signUpHandler(email: emailField.text, password: passwordField.text)
            }
            return b
        }()
        let forgotPasswordButton: UIButton = {
            let b = UIButton()
            b.setTitle("Forgot Password?".localized(), for: .normal)
            b.setTitleColor(Colors.DynamicTextColor, for: .normal)
            _ = b.reactive.tap.observeNext { [weak self] (_) in
                self?.forgotPasswordHandler(email: emailField.text)
            }
            return b
        }()
        
        bottomView.addArrangedSubview(signUpButton)
        bottomView.addArrangedSubview(forgotPasswordButton)
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (this) in
            this.bottom.equalTo(view.snp.bottomMargin)
            this.centerX.equalToSuperview()
        }
    }
    
}
