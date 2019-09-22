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
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            #warning("TODO: Error popup")
            print(error.localizedDescription)
            return
        }
        if let token = AccessToken.current {
            let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
            Auth.auth().signIn(with: credential) { (result, error) in
                if let error = error {
                    #warning("TODO: Error popup")
                    print(error.localizedDescription)
                    return
                }
                // Shouldn't need to do anything here due to the Auth state listener set previously in AppDelegate.
            }
        } else {
            // User cancelled login
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            #warning("TODO: Error popup")
            print(error.localizedDescription)
        }
    }

}


