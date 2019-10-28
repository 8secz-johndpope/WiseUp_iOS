//
//  StoreItem.swift
//  QuickFin
//
//  Created by Boyuan Xu on 10/28/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import Foundation

struct StoreItem: Codable {
    var imageURL = String()
    var name = String()
    var details = String()
    var cost = Int()
}
