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
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                ErrorMessageHandler.shared.showMessage(theme: .error, title: "Sign in error", body: error.localizedDescription)
                return
            }
            
            #warning("TODO: Sync data")
            
            #warning("ADD TO USERS TABLE OR VERIFY USERS TABLE EXISTS")
        }
    }
    
    func signUpHandler(email: String?, password: String?) {
        guard let email = email, let password = password else {
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                ErrorMessageHandler.shared.showMessage(theme: .error, title: "Sign up error", body: error.localizedDescription)
                return
            }
            
        }
        
        #warning("TODO: Sync data")
        
        #warning("ADD TO USERS TABLE OR VERIFY USERS TABLE EXISTS")

    }
    
    func forgotPasswordHandler(email: String?) {
        guard let email = email else {
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                ErrorMessageHandler.shared.showMessage(theme: .error, title: "Password reset error", body: error.localizedDescription)
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
            ErrorMessageHandler.shared.showMessage(theme: .error, title: "Facebook sign in error", body: error.localizedDescription)
            return
        }
        if let token = AccessToken.current {
            let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
            Auth.auth().signIn(with: credential) { (result, error) in
                if let error = error {
                    ErrorMessageHandler.shared.showMessage(theme: .error, title: "Facebook sign in error", body: error.localizedDescription)
                    return
                }
                // Shouldn't need to do anything here due to the Auth state listener set previously in AppDelegate.
                FirebaseService.shared.verifyUser(email: Auth.auth().currentUser?.email ?? "")
            }
        } else {
            // User cancelled login
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            ErrorMessageHandler.shared.showMessage(theme: .error, title: "Sign out error", body: error.localizedDescription)
        }
    }

}
