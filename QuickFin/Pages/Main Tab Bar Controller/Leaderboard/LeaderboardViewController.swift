//
//  LeaderboardViewController.swift
//  QuickFin
//
//  Created by Kevin Yeung on 10/23/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import Localize_Swift
import Firebase
import CodableFirebase

class LeaderboardViewController: BaseViewController {
    
    var tableView = UITableView()
    
    
    var userImages = [UIImage]()
    var userNames = [String]()
    var trophyCounts = [Int]()
        

    func setTableView() {
        tableView.frame = self.view.frame
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear
        tableView.backgroundColor = UIColor.clear
        self.view.addSubview(tableView)
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Leaderboard".localized()
        setBackground()
        
        FirebaseService.shared.getUserData { (usersList) in
            for user in usersList {
                print("user's achievementCount: ", user.achievementCount)
                self.trophyCounts.append(user.achievementCount)
                if user.displayName.isEmpty {
                    print("user has no displayName")
                    self.userNames.append("No DisplayName")
                }
                else {
                    //print("user's displayName: ", user.displayName)
                    self.userNames.append(user.displayName)
                }

                
            }   //end of firebaseService for loop

           // print ("userNames Array on line 58:", self.userNames)
            //print ("achieveCounts Array on line 59:", self.trophyCounts)
            
            //populate userImages list with placeholder blank icons for now
            for i in 0...self.userNames.count - 1 {
                let image = UIImage(named: "Blank User Icon")
                if image != nil {
                    self.userImages.append(UIImage(named: "Blank User Icon")!)
                }
                //print ("photo", userImages[i])
            }
            
            self.setTableView()
            
        }   //end of FirebaseService.shared.getUserData
        
    }   //end of viewDidLoad
        
}       //end of LeaderboardViewController


extension LeaderboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //should be the # of desired cells, length of one of the user arrays
        return self.userNames.count
        
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
    
}   //end of extension LeaderboardViewController
