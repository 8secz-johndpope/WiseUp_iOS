//
//  GameView.swift
//  QuickFin
//
//  Created by Boyuan Xu on 10/14/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit

// MARK: - UI
extension GameViewController {
    
    func initUI() {
        title = "Question"
        let questionLabel: UILabel = {
            let l = UILabel()
            l.text = currentQuestion.question
            l.font = UIFont.boldSystemFont(ofSize: 20)
            return l
        }()
    }
    
}

// MARK: - TableView UI
extension GameViewController: UITableViewDataSource, UITableViewDelegate {
    
    func initTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GameTableViewCell.self, forCellReuseIdentifier: reuseID)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentQuestion.answerOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! GameTableViewCell
        let cellText = currentQuestion.answerOptions[indexPath.row]
        if cellText == currentQuestion.answer {
            cell.isCorrect = true
        }
        cell.titleLabel.text = cellText
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if currentQuestion.answer == currentQuestion.answerOptions[indexPath.row] {
            countCorrect += 1
        } else {
            countIncorrect += 1
        }
        
    }
    
    
}
