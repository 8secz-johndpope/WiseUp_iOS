//
//  AboutViewController.swift
//  QuickFin
//
//  Created by Boyuan Xu on 11/14/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import SnapKit

class AboutViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    let cellReuseID = "about"
    let aboutDataSource: [Int: (String, String)] = [
        0:("Version".localized(), "0.0.1")
    ]
    var aboutTableView: UITableView!
}

// MARK: - UI
extension AboutViewController: UITableViewDataSource, UITableViewDelegate {
    
    func initUI() {
        title = "About".localized()
        
        aboutTableView = UITableView(frame: .zero, style: .insetGrouped)
        aboutTableView.delegate = self
        aboutTableView.dataSource = self
        aboutTableView.register(AboutTableViewCell.self, forCellReuseIdentifier: cellReuseID)
        
        view.addSubview(aboutTableView)
        aboutTableView.snp.makeConstraints { (this) in
            this.top.equalToSuperview()
            this.bottom.equalToSuperview()
            this.leading.equalToSuperview()
            this.trailing.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aboutDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID, for: indexPath) as! AboutTableViewCell
        cell.leftLabel.text = aboutDataSource[indexPath.row]?.0
        cell.rightLabel.text = aboutDataSource[indexPath.row]?.1
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
