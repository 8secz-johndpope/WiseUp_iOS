//
//  FriendsTableViewController.swift
//  QuickFin
//
//  Created by Boyuan Xu on 1/18/20.
//  Copyright © 2020 Fidelity Investments. All rights reserved.
//

import UIKit
import SnapKit
import SwipeCellKit
import GradientLoadingBar

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
    var friendsDictionary = [String: [User]]()
    var friendSectionTitles = [String]()
    var tableView: UITableView!
    let cellReuseID = "friend"
    
    func fetchFriends() {
        FirebaseService.shared.getFriends(completion: { (friendsArray) in
            if let friendsArray = friendsArray {
                self.friends = friendsArray
                self.processIndex()
                self.tableView.reloadData()
            }
        })
    }
    
    func resetIndex() {
        friendsDictionary = [String: [User]]()
        friendSectionTitles = [String]()
    }
    
    func processIndex() {
        resetIndex()
        for friend in friends {
            let friendInitial = String(friend.displayName.prefix(1))
            if var friendValues = friendsDictionary[friendInitial] {
                friendValues.append(friend)
                friendsDictionary[friendInitial] = friendValues
            } else {
                friendsDictionary[friendInitial] = [friend]
            }
        }
        friendSectionTitles = [String](friendsDictionary.keys)
        friendSectionTitles.sort(by: { $0 < $1 })
    }
    
    func getFriendObject(indexPath: IndexPath) -> User {
        let friendInitial = friendSectionTitles[indexPath.section]
        if let friendValues = friendsDictionary[friendInitial] {
            return friendValues[indexPath.row]
        }
        return User()
    }
    
    func deleteFriend(indexPath: IndexPath) {
        GradientLoadingBar.shared.fadeIn()
        FirebaseService.shared.removeFriend(friend: getFriendObject(indexPath: indexPath)) { (success) in
            if success {
                self.friends = self.friends.filter() { $0 != self.getFriendObject(indexPath: indexPath) }
                self.processIndex()
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                ErrorMessageHandler.shared.showMessage(theme: .error, title: Text.Error, body: Text.FriendDeletionErrorMessage)
            }
            GradientLoadingBar.shared.fadeOut()
        }
    }
    
}

// MARK: - UI
extension FriendsTableViewController {
    
    func initUI() {
        title = Text.FriendsNavTitle
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
}

extension FriendsTableViewController: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return friendSectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return friendSectionTitles[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return friendSectionTitles
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let friendInitial = friendSectionTitles[section]
        if let friendValues = friendsDictionary[friendInitial] {
            return friendValues.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID, for: indexPath) as! FriendsTableViewCell
        cell.delegate = self
        let friend = getFriendObject(indexPath: indexPath)
        cell.profileImageView.image = UIImage(named: friend.avatar)
        cell.usernameLabel.text = friend.displayName
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        var actions = [SwipeAction]()
        if orientation == .left {
            let deleteAction = SwipeAction(style: .destructive, title: Text.Delete) { (action, indexPath) in
                self.deleteFriend(indexPath: indexPath)
            }
            actions.append(deleteAction)
        } else {
            let inviteAction = SwipeAction(style: .default, title: Text.Invite) { (action, indexPath) in
                print("[DEBUG] Invite pressed on user \(self.friends[indexPath.row])")
            }
            actions.append(inviteAction)
        }
        return actions
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        #warning("TODO: Display friend info?")
    }
    
}
