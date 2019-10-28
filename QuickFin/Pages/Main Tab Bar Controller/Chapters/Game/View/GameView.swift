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
    
    func initNav() {
        title = "Question".localized() + " \(questionNumber!)"
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Skip".localized(), style: .plain, target: self, action: #selector(proceedToNextVC)), animated: true)
        navigationItem.leftItemsSupplementBackButton = true
    }
    
    func initUI() {
        questionLabel = {
            let l = UILabel()
            l.text = "\n" + currentQuestion.question + "\n"   // Hacky!
            l.font = UIFont.boldSystemFont(ofSize: 25)
            l.numberOfLines = 0
            return l
        }()
        
        let progressBar: UIProgressView = {
            let p = UIProgressView(progressViewStyle: .default)
            return p
        }()
        
        view.addSubview(progressBar)
        progressBar.snp.makeConstraints { (this) in
            this.leading.equalToSuperview()
            this.trailing.equalToSuperview()
            this.top.equalTo(view.snp.topMargin)
            this.height.equalTo(5)
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (this) in
            this.leading.equalTo(view.snp.leading).offset(20)
            this.trailing.equalTo(view.snp.trailing).offset(-20)
            this.top.equalTo(progressBar.snp.bottom)
            this.bottom.equalToSuperview()
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
        tableView.layer.masksToBounds = false
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
        if currentQuestion.answer == currentQuestion.answerOptions[indexPath.section] {
            navigationItem.rightBarButtonItem?.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
                self.proceedToNextVC()
            }
        } else {
            attempts += 1
        }
        answered = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return currentQuestion.answerOptions.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return questionLabel.requiredHeight(width: tableView.frame.width)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return questionLabel
        }
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }
    
}
