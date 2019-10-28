//
//  LeaderboardViewController.swift
//  QuickFin
//
//  Created by Connor Buckley on 10/14/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import Localize_Swift

class LeaderboardViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Leaderboard".localized()
        setBackground()
        fetchData()
        initUI()
    }
    
    var tableView: UITableView!
    let reuseID = "leaderboard"
    var friends = [User]()
    let timeframeOptions = ["Weekly".localized(), "Monthly".localized(), "All time".localized()]
    
    func fetchData() {
        #warning("TODO: Fetch real data")
        friends = []
    }
}
