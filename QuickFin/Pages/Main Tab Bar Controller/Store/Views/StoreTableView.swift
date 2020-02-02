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
            this.top.equalTo(view.snp.topMargin).offset(55)
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
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! StoreTableViewCell
        cell.thumbnail.image = FirebaseService.shared.getImage(URL: storeItems[indexPath.row].imageName)
        cell.titleLabel.text = storeItems[indexPath.row].name
        //let toDouble = Double(storeItems[indexPath.row].cost.description)
        cell.numberLabel.text = storeItems[indexPath.row].cost.description
        cell.descriptionLabel.text = storeItems[indexPath.row].details
        cell.initUI()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailsVC = StoreItemDetailsViewController()
        detailsVC.item = storeItems[indexPath.row]
        present(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
