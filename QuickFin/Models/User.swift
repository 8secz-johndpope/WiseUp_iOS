//
//  User.swift
//  QuickFin
//
//  Created by Boyuan Xu on 9/23/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import Foundation

struct User: Codable {
    
    var admin = Bool()
    var email = String()
    var uid = String()
    var avatar = String()
    
    var coins = Int()
    var completed: [String]
    var achievementsCompleted: [String]
    var experience = Int()
    var inProgress = String()

    var fName = String()
    var lName = String()
    var achievementCount = Int()
    var displayName = String()
    
    init() {
        self.completed = []
        self.achievementsCompleted = []
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
    
}
