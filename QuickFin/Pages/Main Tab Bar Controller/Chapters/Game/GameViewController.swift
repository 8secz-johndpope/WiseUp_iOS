//
//  GameViewController.swift
//  QuickFin
//
//  Created by Connor Buckley on 10/14/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import Localize_Swift

class GameViewController: BaseViewController {
    
    var answered = false
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
        getCurrentQuestion()
        initNav()
        initTableView()
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if answered {
            navigationItem.hidesBackButton = true
            navigationItem.setLeftBarButton(UIBarButtonItem(title: "Chapters".localized(), style: .plain, target: self, action: #selector(popToRootVC)), animated: true)
            navigationItem.rightBarButtonItem?.title = "Next"
        } else {
            navigationItem.hidesBackButton = false
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem?.title = "Skip"
        }
    }
    
    func getCurrentQuestion() {
        currentQuestion = questions[questionNumber-1]
    }
    
    @objc func proceedToNextVC() {
        answered = true
        if questionNumber == questions.count {
            let nextVC = ResultsViewController()
            nextVC.countCorrect = countCorrect
            nextVC.countIncorrect = countIncorrect
            navigationController?.pushViewController(nextVC, animated: true)
        } else {
            let nextVC = GameViewController()
            nextVC.countCorrect = countCorrect
            nextVC.countIncorrect = countIncorrect
            nextVC.questionNumber = questionNumber + 1
            nextVC.questions = questions
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @objc func popToRootVC() {
        print("Test")
        navigationController?.popToRootViewController(animated: true)
    }
    
}


