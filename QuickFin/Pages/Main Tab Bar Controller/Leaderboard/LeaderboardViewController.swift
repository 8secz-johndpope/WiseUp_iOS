//
//  LeaderboardViewController.swift
//  QuickFin
//
//  Created by Kevin Yeung on 10/23/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import Localize_Swift

//class UserModal {
//    var userImage: UIImage?
//    var name: String?
//
//
//    init (userImage: UIImage, name: String) {
//        self.userImage = userImage
//        self.name = name
//
//    }
//}

class LeaderboardViewController: BaseViewController {
    
    var tableView = UITableView()
    
    //var userModal = [UserModal]()
    
    var userImages = [UIImage]()
    var userNames = [String]()
    var trophyCounts = [Int]()

    func setTableView() {
        tableView.frame = self.view.frame
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.gray
        tableView.backgroundColor = UIColor.clear
        self.view.addSubview(tableView)
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Leaderboard".localized()
        setBackground()
        setTableView()
        
        //populate userImages array
        for i in 0...19 {
            let image = UIImage(named: "Blank User Icon")
            if image != nil {
                userImages.append(UIImage(named: "Blank User Icon")!)
            }
            print ("photo", userImages[i])
        }
        
        //populate userNames array
        for index in 0...19 {
            userNames.append("Name\(index)")
            print ("name", userNames[index])
        }
        
        for index in 0...19 {
            trophyCounts.append(index)
            print ("trophyCount", trophyCounts[index])
        }
        
//        for i in 0...userModal.count {
//            print ("i: ", i)
//            var imageString = "\(i).png"
//            //ImageView.image = UIImage(named: "Profile Image")
//            userModal.append(UIImage(named: "Profile Image"))
//        }
        
    }
        
}

extension LeaderboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //should be the # of desired cells, which is probably the length of one of the arrays
        //hardcoded to 10 for now
        print ("size of userImages Array:", String(userImages.count))
        return 10
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomTableViewCell else {fatalError("Unable to create tableView Cell")}
        cell.userImage.image = userImages[indexPath.row]
        cell.nameLabel.text = userNames[indexPath.row]
        cell.trophyCount.text = String(trophyCounts[indexPath.row])
        cell.trophyImage.image = UIImage(named: "Rank")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118  //changing this causes cells to bunch up vertically
    }
    
}

