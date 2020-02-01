//
//  StockItem.swift
//  QuickFin
//
//  Created by Tianjian Xu on 1/31/20.
//  Copyright © 2020 Fidelity Investments. All rights reserved.
//

import Foundation

struct Stock: Codable, Equatable {
    
    var name = String()
    var details = String()
    var currentPrice = Int()
    var numOfShare = Int()
    var buyInPrice = Int()
    var imageName = String()
    var uid = String()
}
