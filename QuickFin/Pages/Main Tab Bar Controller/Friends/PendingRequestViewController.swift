//
//  PendingRequestViewController.swift
//  QuickFin
//
//  Created by Xu on 2/1/20.
//  Copyright © 2020 Fidelity Investments. All rights reserved.
//

import UIKit
import SnapKit
import SwipeCellKit

class PendingRequestViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.fetchFriends()
    }
    
    weak var delegate: FriendsTableViewControllerDelegate?
    var pendingRequests = [User]()
    var tableView: UITableView!
    let cellReuseID = "requests"
    
}

// MARK: - UI
extension PendingRequestViewController: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    
    func initUI() {
        title = Text.FriendPendingRequestTitle
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FriendsTableViewCell.self, forCellReuseIdentifier: cellReuseID)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (this) in
            this.leading.equalToSuperview()
            this.trailing.equalToSuperview()
            this.top.equalToSuperview()
            this.bottom.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID, for: indexPath) as! FriendsTableViewCell
        cell.delegate = self
        let friend = pendingRequests[indexPath.row]
        cell.profileImageView.image = UIImage(named: friend.avatar)
        cell.usernameLabel.text = friend.displayName
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        var actions = [SwipeAction]()
        let friend = pendingRequests[indexPath.row]
        if orientation == .left {
            let deleteAction = SwipeAction(style: .destructive, title: Text.Decline) { [unowned self] (action, indexPath) in
                FirebaseService.shared.declineFriendRequest(friendUID: friend.uid) { (error) in
                    if let error = error {
                        MessageHandler.shared.showMessageModal(theme: .error, title: Text.Error, body: error.localizedDescription)
                    }
                    self.tableView.reloadData()
                }
            }
            actions.append(deleteAction)
        } else {
            let acceptAction = SwipeAction(style: .default, title: Text.Accept) { [unowned self] (action, indexPath) in
                FirebaseService.shared.acceptFriendRequest(friendUID: friend.uid) { (error) in
                    if let error = error {
                        MessageHandler.shared.showMessageModal(theme: .error, title: Text.Error, body: error.localizedDescription)
                    }
                    self.tableView.reloadData()
                }
            }
            acceptAction.backgroundColor = .systemGreen
            actions.append(acceptAction)
        }
        return actions
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
