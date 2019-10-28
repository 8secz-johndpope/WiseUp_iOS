//
//  User.swift
//  QuickFin
//
//  Created by Boyuan Xu on 9/23/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import Foundation

struct User: Codable {
    var email = String()
    var dob = Date()
    var avatar = String()
    var exp = Int()
    var fName = String()
    var lName = String()
    
    func getName() -> String {
        return "\(fName) \(lName)"
    }
}
