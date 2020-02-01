//
//  Friend.swift
//  QuickFin
//
//  Created by Xu on 1/31/20.
//  Copyright © 2020 Fidelity Investments. All rights reserved.
//

import Foundation

struct Friend: Codable {
    var pending = Bool()
    var uids = [String]()
}
