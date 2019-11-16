//
//  ApplicationSettingsViewController.swift
//  QuickFin
//
//  Created by Boyuan Xu on 11/15/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import SnapKit

class ApplicationSettingsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    var tableView: UITableView!
    let cellReuseID = "applicationSettings"
    let menu = [
        "Change Username",
        "Hints",
        "Language",
        "Link Accounts",
        "Notifications"
    ]
}

// MARK: - UI
extension ApplicationSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func initUI() {
        title = "Application Settings".localized()
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
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
        cell.textLabel?.text = menu[indexPath.row].localized()
        cell.textLabel?.textColor = Colors.DynamicTextColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch menu[indexPath.row] {
        case "Change Username".localized():
            navigationController?.pushViewController(ChangeUsernameViewController(), animated: true)
            break
        case "Hints".localized():
            navigationController?.pushViewController(HintsViewController(), animated: true)
            break
        case "Notifications".localized():
            navigationController?.pushViewController(NotificationsViewController(), animated: true)
            break
        default:
            break
        }
    }
}
