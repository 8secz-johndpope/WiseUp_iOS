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
    
    var completed: [String]
    var experience = Int()
    var inProgress = String()

    var fName = String()
    var lName = String()
    
    init(admin: Bool, email: String, uid: String) {
        self.admin = admin
        self.email = email
        self.uid = uid
        self.completed = []
        self.experience = 0
        self.inProgress = ""
    }
    
    func getName() -> String {
        return "\(fName) \(lName)"
    }
    
}
