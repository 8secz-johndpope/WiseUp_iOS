//
//  HintsViewController.swift
//  QuickFin
//
//  Created by Boyuan Xu on 11/15/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import SnapKit

class HintsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    var tableView: UITableView!
    let cellReuseID = "hintsSettings"
    let menu = ["Basic hints".localized()]
    
    @objc func basicHintsToggle() {
        #warning("TODO: Toggle hints logic")
        print("Basic hints toggled")
    }
}

// MARK: - UI
extension HintsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func initUI() {
        title = "Hints".localized()
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
        cell.rightToggle.setOn(true, animated: false)
        
        switch menu[indexPath.row] {
        case "Basic hints".localized():
            cell.rightToggle.addTarget(self, action: #selector(basicHintsToggle), for: .valueChanged)
            break
        default:
            break
        }
        
        return cell
    }
}
