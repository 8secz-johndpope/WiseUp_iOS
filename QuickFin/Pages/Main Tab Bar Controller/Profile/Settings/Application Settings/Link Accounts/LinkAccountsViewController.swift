//
//  LinkAccountsViewController.swift
//  QuickFin
//
//  Created by Boyuan Xu on 11/15/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class LinkAccountsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    var tableView: UITableView!
    let cellReuseID = "linkAccount"
    let menu = [
        "Link with Email".localized(),
        "Link with Facebook".localized(),
        "Link with Google".localized()
    ]
}

// MARK: - UI
extension LinkAccountsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func initUI() {
        title = "Link Accounts".localized()
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseID)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (this) in
            this.top.equalToSuperview()
            this.bottom.equalToSuperview()
            this.leading.equalToSuperview()
            this.trailing.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID, for: indexPath)
        cell.textLabel?.text = menu[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(EmailLinkViewController(), animated: true)
            break
        case 1:
            FBLoginHandler { (result) in
                if let result = result {
                    let credential = FacebookAuthProvider.credential(withAccessToken: result.token!.tokenString)
                    Auth.auth().currentUser?.link(with: credential, completion: { (result, error) in
                        if let error = error {
                            MessageHandler.shared.showMessageModal(theme: .error, title: Text.Error, body: error.localizedDescription)
                            return
                        }
                        MessageHandler.shared.showMessageModal(theme: .success, title: "Success".localized(), body: "Accounts linked.".localized())
                    })
                }
                MessageHandler.shared.showMessageModal(theme: .error, title: Text.Error, body: "Link account failed.".localized())
            }
            break
        case 2:
            GIDSignInHandler()
            break
        default:
            break
        }
    }
    
}

// MARK: - FB Login Handler
extension LinkAccountsViewController {
    
    func FBLoginHandler(completion: @escaping (LoginManagerLoginResult?) -> Void) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if let error = error {
                MessageHandler.shared.showMessageModal(theme: .error, title: Text.Error, body: error.localizedDescription)
                completion(nil)
            }
            completion(result)
        }
    }
    
}

// MARK: - Google Login Handler
extension LinkAccountsViewController: GIDSignInDelegate {
    
    func GIDSignInHandler() {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard let auth = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        Auth.auth().currentUser?.link(with: credential, completion: { (result, error) in
            if let error = error {
                MessageHandler.shared.showMessageModal(theme: .error, title: Text.Error, body: error.localizedDescription)
                return
            }
            MessageHandler.shared.showMessageModal(theme: .success, title: "Success".localized(), body: "Accounts linked.".localized())
        })
    }
}
