//
//  Chapter.swift
//  QuickFin
//
//  Created by Connor Buckley on 9/22/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import Foundation

class Chapter: Codable {
    var name: String
    var questions: [Question]
    var order: Int
    var active: Bool
    var imageName: String
}
