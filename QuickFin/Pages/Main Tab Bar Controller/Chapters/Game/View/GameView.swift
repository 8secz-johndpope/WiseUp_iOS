//
//  GameView.swift
//  QuickFin
//
//  Created by Boyuan Xu on 10/14/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import Bond

// MARK: - UI
extension GameViewController {
    
    func initNav() {
        title = "Question".localized() + " \(questionNumber!)"
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Skip".localized(), style: .plain, target: self, action: #selector(skip)), animated: true)
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
            p.progress = Float(questionNumber-1)/Float(questions.count)
            p.progressTintColor = Colors.FidelityGreen
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
        
        if let activeItem = UserShared.shared.activeItem {
            let activeItemIcon: UIButton = {
                let v = UIButton()
                v.setImage(UIImage(named: activeItem.imageName), for: .normal)
                _ = v.reactive.tap.observeNext { (_) in
                    MessageHandler.shared.showActiveItem(body: "\(activeItem.name): \(activeItem.details)")
                }
                v.alpha = 0.5
                return v
            }()
            view.addSubview(activeItemIcon)
            activeItemIcon.snp.makeConstraints { (this) in
                this.bottom.equalTo(view.snp.bottomMargin).offset(-10)
                this.trailing.equalToSuperview().offset(-10)
                this.width.equalTo(50)
                this.height.equalTo(50)
            }
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
    
    //this is called when an answer is clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // actual answer = the selected answer
        if currentQuestion.answer == currentQuestion.answerOptions[indexPath.section] {
            for cell in tableView.visibleCells {
                if cell != tableView.cellForRow(at: indexPath) {
                    (cell as! GameTableViewCell).tappped(correct: false)
                }
            }
            tableView.isUserInteractionEnabled = false
            navigationItem.rightBarButtonItem?.isEnabled = false
            MessageHandler.shared.gameDelegate = self
            MessageHandler.shared.showMessageOnCorrectChoice(body: currentQuestion.correctAnswerMessage)
            
        } else { //if a question is answered wrong
            attempts += 1
            tableView.cellForRow(at: indexPath)?.isUserInteractionEnabled = false
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
