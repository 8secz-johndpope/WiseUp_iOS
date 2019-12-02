//
//  UserShared.swift
//  QuickFin
//
//  Created by Connor Buckley on 11/13/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import Foundation

struct UserShared: Codable {
    
    static var shared = UserShared()
    
    var admin = Bool()
    var email = String()
    var uid = String()
    var avatar = String()
    var avatarsOwned: [String]
    var itemsOwned: [String]
    
    var coins = Int()
    var completed: [String]
    var achievementsCompleted: [String]
    var experience = Int()
    var inProgress = String()
    var activeItem: StoreItem?

    var fName = String()
    var lName = String()
    var achievementCount = Int()
    var displayName = String()
    
    init() {
        self.completed = []
        self.achievementsCompleted = []
        self.avatarsOwned = ["Blank User Icon"]
        self.avatar = "Blank User Icon"
        self.itemsOwned = []
        self.activeItem = StoreItem()
    }
    
    init(admin: Bool, email: String, uid: String, displayName: String) {
        self.admin = admin
        self.email = email
        self.uid = uid
        self.completed = []
        self.achievementsCompleted = []
        self.experience = 0
        self.inProgress = ""
        self.displayName = displayName
        self.achievementCount = 0
        
        self.activeItem = StoreItem()
        
        self.itemsOwned = []
        self.avatarsOwned = ["Blank User Icon"]
        self.avatar = "Blank User Icon"
    }
    
    func getName() -> String {
        return "\(fName) \(lName)"
    }
    
    mutating func triggerAchievement(AchievementName: String) -> Bool {
        
        if (achievementsCompleted.contains(AchievementName)) {
            return false
        } else {
            achievementCount += 1
            achievementsCompleted.append(AchievementName)
            return true
        }
    }
    
    mutating func clearData() {
        admin = false
        email = ""
        uid = ""
        avatar = ""
        coins = 0
        completed = []
        achievementsCompleted = []
        experience = 0
        inProgress = ""
        fName = ""
        lName = ""
        achievementCount = 0
        displayName = ""
    }
}

