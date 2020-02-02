//
//  VersusRoom.swift
//  QuickFin
//
//  Created by Xu on 2/1/20.
//  Copyright © 2020 Fidelity Investments. All rights reserved.
//

import Foundation

struct VersusRoom: Codable {
    var allJoined = false
    var autoID: String?
    var chapterName = String()
    var uid0 = String()
    var uid1 = String()
    var p0Answers = [String]()
    var p1Answers = [String]()
}
