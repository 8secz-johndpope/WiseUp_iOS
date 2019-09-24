//
//  Chapter.swift
//  QuickFin
//
//  Created by Connor Buckley on 9/22/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import Foundation

class Chapter {
    
    let name: String
    let questions: [String]
    let id: Int
    let active: Bool
    
    init(name: String, questions: [String], active: Bool, id: Int) {
        self.name = name
        self.questions = questions
        self.active = active
        self.id = id
    }
    
}
