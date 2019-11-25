//
//  StoreTableView.swift
//  QuickFin
//
//  Created by Boyuan Xu on 10/28/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import SnapKit
import DropDown
import ReactiveKit

extension StoreViewController {
    
    func initUI() {
        title = "Store".localized()
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

extension StoreViewController: UITableViewDelegate, UITableViewDataSource {

    func initTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StoreTableViewCell.self, forCellReuseIdentifier: reuseID)
        tableView.backgroundColor = .clear
        tableView.sectionHeaderHeight = tableView.estimatedSectionHeaderHeight
        tableView.headerView(forSection: 0)?.layer.masksToBounds = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! StoreTableViewCell
        cell.thumbnail.image = FirebaseService.shared.getImage(URL: storeItems[indexPath.row].imageName)
        cell.titleLabel.text = storeItems[indexPath.row].name
        cell.numberLabel.text = storeItems[indexPath.row].cost.description
        cell.descriptionLabel.text = storeItems[indexPath.row].details
        cell.initUI()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailsVC = StoreItemDetailsViewController()
        detailsVC.item = storeItems[indexPath.row]
        present(detailsVC, animated: true) {
            #warning("TODO: Refresh data")
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = Colors.DynamicNavigationBarColor
        let timeframeButton: UIButton = {
            let b = UIButton()
            b.setTitle(storeSortingOptions[0], for: .normal)
            b.setTitleColor(Colors.DynamicNavigationTitleColor, for: .normal)
            b.setImage("↓".emojiToImage(), for: .normal)
            b.titleLabel?.font = UIFont.systemFont(ofSize: FontSizes.text)
            b.contentEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
            return b
        }()
        let timeframeDropdown: DropDown = {
            let d = DropDown()
            d.anchorView = timeframeButton
            d.dataSource = storeSortingOptions
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
