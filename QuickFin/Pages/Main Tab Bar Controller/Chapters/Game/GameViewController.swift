//
//  GameViewController.swift
//  QuickFin
//
//  Created by Connor Buckley on 10/14/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit

class GameViewController: BaseViewController {
    
    var chapterName: String?
    var answered = false
    var attempts = 0
    var points: Int!
    var questionNumber: Int!
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
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func getCurrentQuestion() {
        currentQuestion = questions[questionNumber-1]
    }
    
    @objc func skip() {
        // Do something
        attempts += 1
        proceedToNextVC()
    }
    
    func proceedToNextVC() {
        tableView.isUserInteractionEnabled = false
        calculatePoints()
        if questionNumber == questions.count {
            let nextVC = ResultsViewController()
            nextVC.points = points
            nextVC.attempts = attempts
            nextVC.chapterName = chapterName
            navigationController?.pushViewController(nextVC, animated: true)
        } else {
            let nextVC = GameViewController()
            nextVC.points = points + 100
            nextVC.questionNumber = questionNumber + 1
            nextVC.questions = questions
            nextVC.attempts = attempts
            nextVC.chapterName = chapterName
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @objc func popToRootVC() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func calculatePoints() {
        #warning("TODO: Implementation")
        if (questionNumber == 1) {
            points = 100
        }
    }
    
}


