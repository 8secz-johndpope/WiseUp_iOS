//
//  GameView.swift
//  QuickFin
//
//  Created by Boyuan Xu on 10/14/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import Localize_Swift

// MARK: - UI
extension GameViewController {
    
    func initNav() {
        title = "Question".localized() + " \(questionNumber!)"
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Skip".localized(), style: .plain, target: self, action: #selector(skip)), animated: true)
    }
    
    func initUI() {
        let progressBar: UIProgressView = {
            let p = UIProgressView(progressViewStyle: .default)
            return p
        }()
        
        let questionLabel: UILabel = {
            let l = UILabel()
            l.text = currentQuestion.question
            l.font = UIFont.boldSystemFont(ofSize: 25)
            return l
        }()
        
        view.addSubview(progressBar)
        progressBar.snp.makeConstraints { (this) in
            this.leading.equalToSuperview()
            this.trailing.equalToSuperview()
            this.top.equalTo(view.snp.topMargin)
            this.height.equalTo(5)
        }
        view.addSubview(questionLabel)
        questionLabel.snp.makeConstraints { (this) in
            this.leading.equalToSuperview().offset(20)
            this.trailing.equalToSuperview().offset(-20)
            this.top.equalTo(view.snp.topMargin).offset(20)
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (this) in
            this.leading.equalTo(questionLabel.snp.leading)
            this.trailing.equalTo(questionLabel.snp.trailing)
            this.top.equalTo(questionLabel.snp.bottom).offset(10)
            this.bottom.equalToSuperview().offset(-20)
        }
        
    }
    
}

// MARK: - TableView UI
extension GameViewController: UITableViewDataSource, UITableViewDelegate {
    
    func initTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GameTableViewCell.self, forCellReuseIdentifier: reuseID)
        tableView.backgroundColor = .clear
        tableView.bounces = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! GameTableViewCell
        let cellText = currentQuestion.answerOptions[indexPath.section]
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return currentQuestion.answerOptions.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }
    
}
