//
//  Question.swift
//  QuickFin
//
//  Created by Connor Buckley on 9/22/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import Foundation

class Question {
    
    let answer: String
    let answerOptions: [String]
    let id: Int
    let question: String
    let score: Int
    
    // Called from Chapters Constructor to load questions into chapters
    init(data: [String: Any]) {
        self.answer = data["answer"] as! String
        self.answerOptions = data["answerOptions"] as! [String]
        self.id = data["id"] as! Int
        self.question = data["question"] as! String
        self.score = data["score"] as! Int
    }
}
