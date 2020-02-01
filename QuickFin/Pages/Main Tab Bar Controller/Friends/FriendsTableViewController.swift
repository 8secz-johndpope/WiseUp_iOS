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

protocol FriendsTableViewControllerDelegate: class {
    func fetchFriends()
}

class FriendsTableViewController: BaseViewController, FriendsTableViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchFriends()
    }
    
    var friends = [User]()
    var pendingRequests = [User]()
    var friendsDictionary = [String: [User]]()
    var friendSectionTitles = [String]()
    var tableView: UITableView!
    let cellReuseID = "friend"
    let group = DispatchGroup()
    
    func fetchFriends() {
        GradientLoadingBar.shared.fadeIn()
        FirebaseService.shared.getFriends { [unowned self] (friendsArray, error) in
            if let error = error {
                MessageHandler.shared.showMessage(theme: .error, title: Text.Error, body: error.localizedDescription)
            } else {
                self.friends = friendsArray!
                self.filterPending()
            }
        }
    }
    
    func filterPending() {
        var newFriends = [User]()
        var newPendingRequests = [User]()
        for friend in friends {
            if friend.isFriendPending() {
                group.enter()
                FirebaseService.shared.getPendingFriendRequest(friendUID: friend.uid) { [unowned self] (friendObj, error) in
                    if let error = error {
                        MessageHandler.shared.showMessage(theme: .error, title: Text.Error, body: error.localizedDescription)
                        print("line 64")
                        print(friend.uid)
                    } else {
                        if friendObj != nil {
                            newPendingRequests.append(friend)
                        }
                    }
                    self.group.leave()
                }
            } else {
                newFriends.append(friend)
            }
        }
        group.notify(queue: .main) { [unowned self] in
            self.friends = newFriends
            self.pendingRequests = newPendingRequests
            self.processIndex()
            self.tableView.reloadData()
            self.navigationItem.leftBarButtonItem?.action = #selector(self.viewIncomingRequests)
            self.navigationItem.rightBarButtonItem?.action = #selector(self.addFriend)
            GradientLoadingBar.shared.fadeOut()
        }
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
        FirebaseService.shared.removeFriend(friend: getFriendObject(indexPath: indexPath)) { (error) in
            GradientLoadingBar.shared.fadeOut()
            if let error = error {
                MessageHandler.shared.showMessage(theme: .error, title: Text.Error, body: error.localizedDescription)
            } else {
                self.fetchFriends()
            }
        }
    }
    
    @objc func addFriend() {
        let nextVC = AddFriendViewController()
        nextVC.delegate = self
        present(nextVC, animated: true, completion: nil)
    }
    
    @objc func viewIncomingRequests() {
        let nextVC = PendingRequestViewController()
        present(nextVC, animated: true, completion: nil)
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
        
        navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: nil), animated: true)
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil), animated: true)
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
        if friend.isFriendPending() {
            cell.usernameLabel.text = "\(Text.Pending) " + (cell.usernameLabel.text ?? "")
            cell.usernameLabel.alpha = 0.5
        }
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
        let friend = getFriendObject(indexPath: indexPath)
        if !friend.isFriendPending() {
            #warning("TODO: Display friend info?")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
