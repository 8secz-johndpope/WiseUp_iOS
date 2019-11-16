//
//  LinkAccountsViewController.swift
//  QuickFin
//
//  Created by Boyuan Xu on 11/15/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import SnapKit

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
        default:
            break
        }
    }
    
}
