//
//  NotificationsViewController.swift
//  QuickFin
//
//  Created by Boyuan Xu on 11/15/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import Bond
import SnapKit

class NotificationsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }

    var tableView: UITableView!
    let cellReuseID = "notificationsSettings"
    let menu = ["Push notifications".localized()]
    
    @objc func notificationsToggle() {
        #warning("TODO: Push notifications toggle logic")
        print("Push notifications toggled")
    }
}

// MARK: - UI
extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func initUI() {
        title = "Notifications".localized()
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GenericToggleTableViewCell.self, forCellReuseIdentifier: cellReuseID)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID, for: indexPath) as! GenericToggleTableViewCell
        cell.leftLabel.text = menu[indexPath.row]
        #warning("TODO: Notification settings read from local UserDefaults")
        cell.rightToggle.setOn(true, animated: false)
        
        switch menu[indexPath.row] {
        case "Push notifications".localized():
            cell.rightToggle.addTarget(self, action: #selector(notificationsToggle), for: .valueChanged)
            break
        default:
            break
        }
        
        return cell
    }
}
