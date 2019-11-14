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

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print("In Results VC w/ \(points) points!")
        
        UserShared.shared.experience += points!
        UserShared.shared.coins += points! / 10
        
        checkAchievements()

        FirebaseService.shared.pushUserToFirebase()
        
        initUI()
    }
    
    func checkAchievements() {
        // 2 achievements to check for - Perfect Chapter + Completed Chapter
        // Perfect Chapter
       
        if (attempts == 0) {
           
           let AchievementName = chapterName! + "PerfectChapter"
           
           if (UserShared.shared.triggerAchievement(AchievementName: AchievementName)) {
               AchievementMessageHandler.shared.showMessage(theme: .success, title: "Achievement", body: AchievementName.localized())
           }
           
        }
        
        // Completed Chapter

        let AchievementName = chapterName! + "CompleteChapter"

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
        #warning("TODO - Replace w/ Real level data")
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
            return ring
        }()
        expLabel = {
            let l = UILabel()
            l.font = UIFont.systemFont(ofSize: FontSizes.largeNavTitle, weight: .bold)
            #warning("TODO: Replace dummy data with real data")
            l.text = "+\(points! / 10) Fiddles"
            l.textColor = Colors.DynamicTextColor
            return l
        }()
        motdLabel = {
            let l = UILabel()
            l.font = UIFont.systemFont(ofSize: FontSizes.navTitle, weight: .bold)
            #warning("TODO: Replace dummy data with real data")
            l.text = "Almost there!"
            l.textColor = Colors.DynamicTextColor
            return l
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
    }
}
