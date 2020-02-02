//
//  Core.swift
//  QuickFin
//
//  Created by Boyuan Xu on 9/22/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import Foundation

class Core: Codable {
    
    static var shared = Core()
    private init() {}
    
    var coldStart = true
    var chapters = [Chapter]()
    var currentVersusChapter: Chapter?
    
    func randomChapter() -> Chapter {
        let randomNumber = Int(arc4random_uniform(UInt32(chapters.count)))
        return chapters[randomNumber]
    }
}

