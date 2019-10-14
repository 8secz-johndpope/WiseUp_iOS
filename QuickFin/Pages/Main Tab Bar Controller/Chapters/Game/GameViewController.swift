//
//  GameViewController.swift
//  QuickFin
//
//  Created by Connor Buckley on 10/14/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit

class GameViewController: BaseViewController {
    
    var questionNumber: Int!
    var countCorrect: Int!
    var countIncorrect: Int!
    var questions: [Question]!
    var currentQuestion: Question!
    let reuseID = "game"
    var tableView: UITableView!
    var questionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentQuestionAndIncrement()
        initNav()
        initTableView()
        initUI()
    }
    
    func getCurrentQuestionAndIncrement() {
        currentQuestion = questions[0]
        questions.remove(at: 0)
    }
    
    @objc func skip() {
        
    }
    
}


