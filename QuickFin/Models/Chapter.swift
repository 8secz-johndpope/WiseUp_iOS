//
//  Chapter.swift
//  QuickFin
//
//  Created by Connor Buckley on 9/22/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import Foundation
import CodableFirebase

class Chapter {
    
    var name: String
    var questions: [Question]
    var id: Int
    var active: Bool
    
    init(name: String, questions: [Question], active: Bool, id: Int) {
        self.name = name
        self.questions = questions
        self.active = active
        self.id = id
    }
    
    // Used by Firebase Utility to load Chapters from Firebase
    init(data: [String: Any?]) {
        self.name = data["name"] as! String
        self.questions = [Question]()
        
        // Mess with the following four lines at your own risk
        let questionDict = data["questions"] as! NSArray // Convert to NSArray to allow iteration
        for dat in questionDict {
            self.questions.append(Question(data: dat as! [String : Any])) // Cast to dictionary for constructor of Question
        }
        
        self.active = data["active"] as! Bool
        self.id = data["id"] as! Int
    }
    
}
