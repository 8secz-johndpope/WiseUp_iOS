//
//  LeaderboardTableView.swift
//  QuickFin
//
//  Created by Boyuan Xu on 10/27/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import SnapKit
import DropDown
import ReactiveKit

extension LeaderboardViewController {
    
    func initUI() {
        title = "Leaderboard".localized()
        initTableView()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (this) in
            this.leading.equalToSuperview()
            this.top.equalTo(view.snp.topMargin)
            this.bottom.equalTo(view.snp.bottomMargin)
            this.trailing.equalToSuperview()
        }
    }
}

extension LeaderboardViewController: UITableViewDelegate, UITableViewDataSource {

    func initTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LeaderboardTableViewCell.self, forCellReuseIdentifier: reuseID)
        tableView.backgroundColor = .clear
        tableView.sectionHeaderHeight = tableView.estimatedSectionHeaderHeight
        tableView.headerView(forSection: 0)?.layer.masksToBounds = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! LeaderboardTableViewCell
        cell.titleLabel.text = friends[indexPath.row].getName()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = Colors.DynamicNavigationBarColor
        let timeframeButton: UIButton = {
            let b = UIButton()
            b.setTitle(timeframeOptions[0], for: .normal)
            b.setTitleColor(Colors.DynamicNavigationTitleColor, for: .normal)
            b.setImage("↓".emojiToImage(), for: .normal)
            b.titleLabel?.font = UIFont.systemFont(ofSize: FontSizes.text)
            b.contentEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
            return b
        }()
        let timeframeDropdown: DropDown = {
            let d = DropDown()
            d.anchorView = timeframeButton
            d.dataSource = timeframeOptions
            d.selectionAction = { (index: Int, item: String) in
                timeframeButton.setTitle(item, for: .normal)
                #warning("TODO: Update leaderboard based on new timeframe option")
            }
            d.dismissMode = .automatic
            return d
        }()
        _ = timeframeButton.reactive.tap.observeNext { (_) in
            timeframeDropdown.show()
        }
        
        header.addSubview(timeframeButton)
        timeframeButton.snp.makeConstraints { (this) in
            this.trailing.equalToSuperview().offset(-20)
            this.centerY.equalToSuperview()
            this.height.equalToSuperview()
        }
        
        return header
    }
    
}
