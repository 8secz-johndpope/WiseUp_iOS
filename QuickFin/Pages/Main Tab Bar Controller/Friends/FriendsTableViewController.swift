//
//  FriendsTableViewController.swift
//  QuickFin
//
//  Created by Boyuan Xu on 1/18/20.
//  Copyright © 2020 Fidelity Investments. All rights reserved.
//

import UIKit
import MYTableViewIndex
import SnapKit
import SwipeCellKit

class FriendsTableViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchFriends()
    }
    
    var friends = [User]()
    var tableView: UITableView!
    let cellReuseID = "friend"
    var tableViewIndexController: TableViewIndexController!
    
    func fetchFriends() {
        FirebaseService.shared.getFriends(completion: { (friendsArray) in
            if let friendsArray = friendsArray {
                self.friends = friendsArray
                self.tableView.reloadData()
            }
        })
    }
    
}

// MARK: - UI
extension FriendsTableViewController {
    
    func initUI() {
        title = Text.FriendsNavTitle
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FriendsTableViewCell.self, forCellReuseIdentifier: cellReuseID)
        tableViewIndexController = TableViewIndexController(scrollView: tableView)
        tableViewIndexController.tableViewIndex.dataSource = self
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (this) in
            this.leading.equalToSuperview()
            this.trailing.equalToSuperview()
            this.top.equalToSuperview()
            this.bottom.equalToSuperview()
        }
    }
}

extension FriendsTableViewController: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID, for: indexPath) as! FriendsTableViewCell
        cell.delegate = self
        let friend = friends[indexPath.row]
        cell.profileImageView.image = UIImage(named: friend.avatar)
        cell.usernameLabel.text = friend.displayName
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: Text.Delete) { (action, indexPath) in
            print("[DEBUG] Delete pressed on user \(self.friends[indexPath.row])")
        }
        
        let inviteAction = SwipeAction(style: .default, title: Text.Invite) { (action, indexPath) in
            print("[DEBUG] Invite pressed on user \(self.friends[indexPath.row])")
        }
        
        return [deleteAction, inviteAction]
    }
    
}

extension FriendsTableViewController: TableViewIndexDelegate, TableViewIndexDataSource {
    
    func indexItems(for tableViewIndex: TableViewIndex) -> [UIView] {
        return UILocalizedIndexedCollation.current().sectionIndexTitles.map{ title -> UIView in
            return StringItem(text: title)
        }
    }
    
    func tableViewIndex(_ tableViewIndex: TableViewIndex, didSelect item: UIView, at index: Int) -> Bool {
        let indexPath = IndexPath(row: tableView.numberOfRows(inSection: index), section: index)
        tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        return true // return true to produce haptic feedback on capable devices
    }
    
}
