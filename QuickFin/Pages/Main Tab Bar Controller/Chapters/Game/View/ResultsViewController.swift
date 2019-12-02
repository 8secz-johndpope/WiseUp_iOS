//
//  ResultsViewController.swift
//  QuickFin
//
//  Created by Boyuan Xu on 10/14/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import UICircularProgressRing
import SnapKit

class ResultsViewController: BaseViewController {
    
    var points: Int?
    var attempts: Int?
    var chapterName: String?
    var total: Int = 0
    var skipped: Int = 0
    var coinsGained: Int = 0

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        switch UserShared.shared.activeItem {
        case "Tiny Potion of Knowledge":
            UserShared.shared.experience += Int(Double(points!) * 1.1)
            UserShared.shared.coins += points! / 10
            coinsGained = points! / 10
        case "Potion of Knowledge":
            UserShared.shared.experience += Int(Double(points!) * 1.3)
            UserShared.shared.coins += points! / 10
            coinsGained = points! / 10
        case "Large Potion of Knowledge":
            UserShared.shared.experience += Int(Double(points!) * 1.5)
            UserShared.shared.coins += points! / 10
            coinsGained = points! / 10
        case "Legendary Potion of Knowledge":
            UserShared.shared.experience += Int(Double(points!) * 2)
            UserShared.shared.coins += points! / 10
            coinsGained = points! / 10
        case "Tiny Potion of Riches":
            UserShared.shared.experience += points!
            UserShared.shared.coins += Int(Double(points! / 10) * 1.1)
            coinsGained = Int(Double(points! / 10) * 1.1)
        case "Potion of Riches":
            UserShared.shared.experience += points!
            UserShared.shared.coins += Int(Double(points! / 10) * 1.3)
            coinsGained = Int(Double(points! / 10) * 1.3)
        case "Large Potion of Riches":
            UserShared.shared.experience += points!
            UserShared.shared.coins += Int(Double(points! / 10) * 1.5)
            coinsGained = Int(Double(points! / 10) * 1.5)
        case "Legendary Potion of Riches":
            UserShared.shared.experience += points!
            UserShared.shared.coins += Int(Double(points! / 10) * 2)
            coinsGained = Int(Double(points! / 10) * 2)
        default:
            UserShared.shared.experience += points!
            UserShared.shared.coins += points! / 10
            coinsGained = points! / 10
        }
        
        UserShared.shared.activeItem = ""
                
        checkAchievements()

        FirebaseService.shared.pushUserToFirebase()
        
        initUI()
    }
    
    func checkAchievements() {
        // 2 achievements to check for - Perfect Chapter + Completed Chapter
        // Perfect Chapter
       
        if (attempts == 0) {
           
            let AchievementName = chapterName! + "PerfectChapter".localized();
           
           if (UserShared.shared.triggerAchievement(AchievementName: AchievementName)) {
               AchievementMessageHandler.shared.showMessage(theme: .success, title: "Achievement", body: AchievementName.localized())
           }
           
        }
        
        // Completed Chapter

        let AchievementName = chapterName! + "CompleteChapter".localized();

        if (UserShared.shared.triggerAchievement(AchievementName: AchievementName)) {
           AchievementMessageHandler.shared.showMessage(theme: .success, title: "Achievement", body: AchievementName.localized())
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initNavUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        progressRing.startProgress(to: CGFloat((UserShared.shared.experience % 1000) / 10), duration: 2.0)
    }
    
    @objc func popToRootVC() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    var progressRing: UICircularProgressRing!
    var expLabel: UILabel!
    var motdLabel: UILabel!
}

extension ResultsViewController {
    
    func initNavUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Congratulations!"
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Done".localized(), style: .done, target: self, action: #selector(popToRootVC)), animated: true)
    }
    
    func initUI() {
        progressRing = {
            let ring = UICircularProgressRing()
            #warning("TODO: Replace dummy data with real data")
            ring.maxValue = 100
            ring.style = .ontop
            ring.outerRingColor = .clear
            ring.innerRingColor = Colors.FidelityGreen!
            ring.innerRingWidth = 40
            ring.font = UIFont.systemFont(ofSize: FontSizes.circularProgressNumber, weight: .bold)
            ring.fontColor = Colors.DynamicTextColor!
            return ring
        }()
        expLabel = {
            let l = UILabel()
            l.font = UIFont.systemFont(ofSize: FontSizes.largeNavTitle, weight: .bold)
            #warning("TODO: Replace dummy data with real data")
            l.text = "+\(coinsGained) Coins"
            l.textColor = Colors.DynamicTextColor
            return l
        }()
        motdLabel = {
            let l = UILabel()
            l.font = UIFont.systemFont(ofSize: FontSizes.navTitle, weight: .bold)
            if(skipped != 0){
                l.text = "Skipped \(skipped) of \(total)"
            }else{
                l.text = "No questions skipped!"
            }
            l.textColor = Colors.DynamicTextColor
            return l
        }()
        
        let next: UIButton = {
            let next = UIButton(type: .system)
            next.setTitle("Next", for: .normal)
            next.tintColor = .black
            next.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
            next.contentEdgeInsets = UIEdgeInsets(top: 5,left: 20,bottom: 5,right: 30)
            next.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
            next.layer.cornerRadius = 5
            next.layer.borderWidth = 2
            next.layer.borderColor = UIColor.black.cgColor
            next.setImage(UIImage(named: "Next"), for: .normal)
            return next
        }()
        
        let retry: UIButton = {
            let retry = UIButton(type: .system)
            retry.setTitle("Retry", for: .normal)
            retry.tintColor = .black
            retry.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
            retry.contentEdgeInsets = UIEdgeInsets(top: 5,left: 20,bottom: 5,right: 30)
            retry.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
            retry.backgroundColor = .clear
            retry.layer.cornerRadius = 5
            retry.layer.borderWidth = 2
            retry.layer.borderColor = UIColor.black.cgColor
            retry.setImage(UIImage(named: "Go Back"), for: .normal)
            return retry
        }()
        
        view.addSubview(progressRing)
        progressRing.snp.makeConstraints { (this) in
            this.centerX.equalToSuperview()
            this.top.equalTo(view.snp.topMargin).offset(20)
            this.width.equalToSuperview().offset(-40)
            this.height.equalTo(view.snp.width).offset(-40)
        }
        view.addSubview(expLabel)
        expLabel.snp.makeConstraints { (this) in
            this.top.equalTo(progressRing.snp.bottom).offset(30)
            this.centerX.equalToSuperview()
        }
        view.addSubview(motdLabel)
        motdLabel.snp.makeConstraints { (this) in
            this.top.equalTo(expLabel.snp.bottom).offset(10)
            this.centerX.equalTo(expLabel)
        }
  /*      view.addSubview(next)
        next.snp.makeConstraints { (this) in
            this.top.equalTo(expLabel.snp.bottom).offset(50)
            this.centerX.equalTo(expLabel)
        }
        
        view.addSubview(retry)
        retry.snp.makeConstraints { (this) in
            this.top.equalTo(expLabel.snp.bottom).offset(120)
            this.centerX.equalTo(expLabel)
        }
        */
    }
}
