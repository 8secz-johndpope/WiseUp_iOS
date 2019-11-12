//
//  SettingsView.swift
//  QuickFin
//
//  Created by Boyuan Xu on 10/11/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import SnapKit

extension SettingsViewController {
    
    func initUI() {
        title = "Settings".localized()
    }
}

// MARK: - UITableView setup
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func initTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: cellReuseID)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (this) in
            this.top.equalToSuperview()
            this.bottom.equalToSuperview()
            this.width.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID, for: indexPath) as! SettingsTableViewCell;
        cell.titleLabel.text = settingsMenu[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = settingsMenu[indexPath.row]
        switch title {
        case "Log Out".localized():
            FirebaseService.shared.logOut()
            break
        case "Change Password".localized():
            navigationController?.pushViewController(ChangePasswordViewController(), animated: true)
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}
