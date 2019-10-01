//
//  Question.swift
//  QuickFin
//
//  Created by Connor Buckley on 9/22/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import Foundation

class Question: Codable {
    let answer: String
    let answerOptions: [String]
    let question: String
    let score: Int
}
