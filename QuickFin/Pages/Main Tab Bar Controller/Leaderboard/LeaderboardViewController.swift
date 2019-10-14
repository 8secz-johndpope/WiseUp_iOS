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
        initUI()
    }
        
    func initUI() {
        
    }

}
