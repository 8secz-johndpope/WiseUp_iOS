//
//  VersionTimeStamp.swift
//  QuickFin
//
//  Created by Connor Buckley on 9/30/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import Foundation

class ChapterStats: Codable {
    let timestamp: Int
    let chapterCount: Int
    
    init() {
        timestamp = -1
        chapterCount = -1
    }
}
