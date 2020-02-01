//
//  PendingRequestViewController.swift
//  QuickFin
//
//  Created by Xu on 2/1/20.
//  Copyright © 2020 Fidelity Investments. All rights reserved.
//

import UIKit

class PendingRequestViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    var tableView: UITableView!
    let cellReuseID = "requests"
    
}

// MARK: - UI
extension PendingRequestViewController {
    
    func initUI() {
        title = Text.FriendPendingRequestTitle
    }
}
