//
//  SignInViewController.swift
//  QuickFin
//
//  Created by Boyuan Xu on 9/21/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInViewController: BaseViewController, LoginButtonDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        initUI()
    }
    
    func emailSignInHandler(email: String?, password: String?) {
        guard let email = email, let password = password else {
            return
        }
        if email.isEmpty || password.isEmpty {
            MessageHandler.shared.showMessage(theme: .error, title: "Sign in error", body: "Please complete the fields.".localized())
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                let errorCode = AuthErrorCode(rawValue: error._code)
                switch errorCode {
                case .userNotFound:
                    MessageHandler.shared.showMessage(theme: .error, title: "Sign in error", body: "User does not exist.".localized())
                    break
                case .wrongPassword:
                    MessageHandler.shared.showMessage(theme: .error, title: "Sign in error", body: "Incorrect password.".localized())
                    break
                default:
                    MessageHandler.shared.showMessage(theme: .error, title: "Sign in error", body: error.localizedDescription)
                    break
                }
                return
            }
        }
    }
}

// MARK: - Delegate pattern to automatically sign in
extension SignInViewController: SignInDelegate {
    
    func didSignUp(email: String, password: String) {
        self.emailSignInHandler(email: email, password: password)
    }
}

// MARK: - Facebook sign in logic
extension SignInViewController {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            MessageHandler.shared.showMessage(theme: .error, title: "Facebook sign in error", body: error.localizedDescription)
            return
        }
        if let token = AccessToken.current {
            let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
            Auth.auth().signIn(with: credential) { (result, error) in
                if let error = error {
                    MessageHandler.shared.showMessage(theme: .error, title: "Facebook sign in error", body: error.localizedDescription)
                    return
                }
                // Shouldn't need to do anything here due to the Auth state listener set previously in AppDelegate.
                FirebaseService.shared.verifyUser(email: Auth.auth().currentUser?.email ?? "") { (error) in
                    MessageHandler.shared.showMessage(theme: .error, title: Text.Error, body: error!.localizedDescription)
                }
            }
        } else {
            // User cancelled login
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            MessageHandler.shared.showMessage(theme: .error, title: "Sign out error", body: error.localizedDescription)
        }
    }

}
