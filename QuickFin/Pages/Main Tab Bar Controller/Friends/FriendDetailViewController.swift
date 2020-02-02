//
//  FriendDetailViewController.swift
//  QuickFin
//
//  Created by Xu on 2/1/20.
//  Copyright © 2020 Fidelity Investments. All rights reserved.
//

import UIKit
import SnapKit
import GradientLoadingBar

class FriendDetailViewController: ProfileViewController {
    
    override func viewDidLoad() {
        initUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        GradientLoadingBar.shared.fadeOut()
    }
    
    weak var delegate: FriendsTableViewControllerDelegate?
    var friend: User!
    
    func startVersusGame() {
        // First, create a room
        var room = VersusRoom()
        let chapter = Core.shared.randomChapter()
        room.chapterName = chapter.name
        room.uid0 = UserShared.shared.uid
        room.uid1 = friend.uid
        GradientLoadingBar.shared.fadeIn()
        FirebaseService.shared.setVersusRoom(room: room) { (roomWithID, error) in
            GradientLoadingBar.shared.fadeOut()
            if let error = error {
                MessageHandler.shared.showMessageModal(theme: .error, title: Text.Error, body: error.localizedDescription)
                return
            }
            if let roomWithID = roomWithID {
                room = roomWithID
            }
            // Then, wait for the opponent to join
            GradientLoadingBar.shared.fadeIn()
            FirebaseService.shared.listenForOpponentJoin(room: room) { [unowned self] (error) in
                GradientLoadingBar.shared.fadeOut()
                if let error = error {
                    MessageHandler.shared.showMessageModal(theme: .error, title: Text.Error, body: error.localizedDescription)
                    print("here")
                    return
                }
                // The opponent has joined
                let versusVC = VersusGameViewController()
                versusVC.questionNumber = 1
                versusVC.questions = chapter.questions
                versusVC.chapterName = chapter.name.replacingOccurrences(of: "%20", with: " ")
                self.navigationController?.pushViewController(versusVC, animated: true)
            }
        }
    }
    
    override func fetchData() {
        let xpPercentage = (Double)(friend.experience % 1000) / 1000.0
        xpLevelLabel.text = (friend.experience / 1000).description
        coinBalanceLabel.text = friend.coins.description
        achievementLabel.text = friend.achievementCount.description
        UIView.animate(withDuration: 0.4) {
            self.xpProgressBarFiller.snp.remakeConstraints { (this) in
                this.leading.equalTo(self.xpProgressBarBackgroundView.snp.leading)
                this.height.equalTo(10)
                this.centerY.equalTo(self.xpProgressBarBackgroundView.snp.centerY)
                this.width.equalTo(self.xpProgressBarBackgroundView.snp.width).multipliedBy(xpPercentage)
            }
            self.xpProgressBarFiller.superview?.layoutIfNeeded()
        }
        updateProfileImage()
    }
    
    override func updateProfileImage() {
        profileImageView.image = UIImage(named: friend.avatar)
    }
    
}

extension FriendDetailViewController {
    
    override func initUI() {
        setBackground()
        
        profileImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.image = UIImage(named: friend.avatar)
            return imageView
        }()
        let profileNameLabel: UILabel = {
            let l = UILabel()
            if friend.getName() == " " {
                l.text = friend.displayName
            } else {
                l.text = friend.getName()
            }
            l.font = .boldSystemFont(ofSize: FontSizes.largeNavTitle)
            l.textColor = Colors.DynamicTextColor
            return l
        }()
        
        let horizontalStackView: UIStackView = {
            let v = UIStackView()
            v.axis = .horizontal
            v.distribution = .fillEqually
            v.alignment = .center
            return v
        }()
        
        let coinContainerView = UIView()
        let coinBalanceNameLabel: UILabel = {
            let l = UILabel()
            l.text = "Coins".localized()
            l.font = .boldSystemFont(ofSize: FontSizes.pageTitle)
            l.textColor = Colors.DynamicTextColor
            return l
        }()
        coinBalanceLabel = {
            let l = UILabel()
            l.text = friend.coins.description
            l.font = .systemFont(ofSize: FontSizes.pageTitle)
            l.textColor = Colors.DynamicTextColor
            return l
        }()
    
        let achievementContainerView = UIView()
        let achievementNameLabel: UILabel = {
            let l = UILabel()
            l.text = "Achievements".localized()
            l.font = .boldSystemFont(ofSize: FontSizes.pageTitle)
            l.textColor = Colors.DynamicTextColor
            return l
        }()
        achievementLabel = {
            let l = UILabel()
            l.text = friend.achievementCount.description
            l.font = .systemFont(ofSize: FontSizes.pageTitle)
            l.textColor = Colors.DynamicTextColor
            return l
        }()
        
        let xpImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.image = UIImage(named: "XP")
            return imageView
        }()
        xpProgressBarBackgroundView = UIView()
        xpProgressBarFiller = UIView()
        xpProgressBarFiller.backgroundColor = Colors.FidelityGreen
        
        xpLevelLabel = {
            let l = UILabel()
            l.textColor = Colors.FidelityGreen
            l.font = UIFont.boldSystemFont(ofSize: FontSizes.xpLevel)
            return l
        }()
        
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { (this) in
            this.top.equalTo(view.snp.topMargin).offset(20)
            this.centerX.equalToSuperview()
            this.width.equalTo(150)
            this.height.equalTo(150)
        }
        view.addSubview(profileNameLabel)
        profileNameLabel.snp.makeConstraints { (this) in
            this.top.equalTo(profileImageView.snp.bottom)
            this.centerX.equalToSuperview()
        }
        profileImageView.layer.cornerRadius = 75
        profileImageView.layer.masksToBounds = true
        
        view.addSubview(xpImageView)
        xpImageView.snp.makeConstraints { (this) in
            this.top.equalTo(profileNameLabel.snp.bottom).offset(10)
            this.leading.equalToSuperview().offset(20)
        }
        view.addSubview(xpLevelLabel)
        xpLevelLabel.snp.makeConstraints { (this) in
            this.trailing.equalToSuperview().offset(-20)
            this.centerY.equalTo(xpImageView.snp.centerY)
        }
        view.addSubview(xpProgressBarBackgroundView)
        xpProgressBarBackgroundView.snp.makeConstraints { (this) in
            this.leading.equalTo(xpImageView.snp.trailing).offset(10)
            this.trailing.equalTo(xpLevelLabel.snp.leading).offset(-20)
            this.height.equalTo(10)
            this.centerY.equalTo(xpImageView.snp.centerY)
        }
        view.addSubview(xpProgressBarFiller)
        xpProgressBarFiller.snp.makeConstraints { (this) in
            this.leading.equalTo(xpProgressBarBackgroundView.snp.leading)
            this.height.equalTo(10)
            this.centerY.equalTo(xpProgressBarBackgroundView.snp.centerY)
            this.width.equalTo(xpProgressBarBackgroundView.snp.width).multipliedBy(1)
        }
        xpProgressBarBackgroundView.layer.borderColor = Colors.DynamicTextColor?.cgColor
        xpProgressBarBackgroundView.layer.borderWidth = 0.3
        xpProgressBarBackgroundView.layer.cornerRadius = 5
        xpProgressBarFiller.layer.cornerRadius = 5
        xpProgressBarFiller.layer.shadowColor = Colors.FidelityGreen?.cgColor
        xpProgressBarFiller.layer.shadowOpacity = 0.7
        xpProgressBarFiller.layer.shadowRadius = 7
        xpProgressBarFiller.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        coinContainerView.addSubview(coinBalanceNameLabel)
        coinBalanceNameLabel.snp.makeConstraints { (this) in
            this.top.equalToSuperview()
            this.centerX.equalToSuperview()
        }
        coinContainerView.addSubview(coinBalanceLabel)
        coinBalanceLabel.snp.makeConstraints { (this) in
            this.top.equalTo(coinBalanceNameLabel.snp.bottom)
            this.centerX.equalToSuperview()
        }
        achievementContainerView.addSubview(achievementNameLabel)
        achievementNameLabel.snp.makeConstraints { (this) in
            this.top.equalToSuperview()
            this.centerX.equalToSuperview()
        }
        achievementContainerView.addSubview(achievementLabel)
        achievementLabel.snp.makeConstraints { (this) in
            this.top.equalTo(achievementNameLabel.snp.bottom)
            this.centerX.equalToSuperview()
        }
        horizontalStackView.addArrangedSubview(coinContainerView)
        horizontalStackView.addArrangedSubview(achievementContainerView)
        view.addSubview(horizontalStackView)
        horizontalStackView.snp.makeConstraints { (this) in
            this.top.equalTo(xpImageView.snp.bottom).offset(20)
            this.leading.equalToSuperview()
            this.trailing.equalToSuperview()
        }
        
        let inviteButton: UIButton = {
            let b = UIButton()
            b.setTitle(Text.InviteTo1v1.localized(), for: .normal)
            b.setTitleColor(.white, for: .normal)
            b.titleLabel?.font = UIFont.systemFont(ofSize: FontSizes.pageTitle, weight: .semibold)
            b.backgroundColor = Colors.FidelityGreen
            _ = b.reactive.tap.observeNext { [unowned self] (_) in
                #warning("TODO: Implement")
                GradientLoadingBar.shared.fadeIn()
                b.setTitle(Text.WaitingForOpponent, for: .normal)
                self.startVersusGame()
            }
            b.layer.cornerRadius = 10
            return b
        }()
        
        let deleteButton: UIButton = {
            let b = UIButton()
            b.setTitle(Text.Delete.localized(), for: .normal)
            b.backgroundColor = .systemRed
            b.setTitleColor(.white, for: .normal)
            _ = b.reactive.tap.observeNext { [unowned self] (_) in
                MessageHandler.shared.showGenericWarningMessage {
                    FirebaseService.shared.removeFriend(friend: self.friend) { (error) in
                        if let error = error {
                            MessageHandler.shared.showMessageModal(theme: .error, title: Text.Error, body: error.localizedDescription)
                            return
                        }
                        MessageHandler.shared.showMessageModal(theme: .warning, title: Text.Warning, body: Text.FriendDeleted)
                        self.delegate?.fetchFriends()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            return b
        }()
        
        view.addSubview(inviteButton)
        view.addSubview(deleteButton)
        inviteButton.snp.makeConstraints { (this) in
            this.height.equalTo(60)
            this.left.equalToSuperview().offset(20)
            this.right.equalToSuperview().offset(-20)
            this.top.equalTo(horizontalStackView.snp.bottom).offset(60)
        }
        deleteButton.snp.makeConstraints { (this) in
            this.height.equalTo(60)
            this.left.equalToSuperview()
            this.right.equalToSuperview()
            this.bottom.equalToSuperview()
        }
    }
    
}
