//
//  AddFriendViewController.swift
//  QuickFin
//
//  Created by Boyuan Xu on 1/20/20.
//  Copyright © 2020 Fidelity Investments. All rights reserved.
//

import UIKit
import SnapKit
import SkyFloatingLabelTextField
import GradientLoadingBar

class AddFriendViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    weak var delegate: FriendsTableViewControllerDelegate?
    
}

// MARK: - UI
extension AddFriendViewController {
    
    func initUI() {
        let emailTextField: SkyFloatingLabelTextField = {
            let tf = SkyFloatingLabelTextField()
            tf.title = Text.Email.localized()
            tf.placeholder = Text.Email.localized()
            tf.textColor = Colors.DynamicTextColor
            tf.selectedTitleColor = Colors.FidelityGreen!
            tf.selectedLineColor = Colors.FidelityGreen!
            tf.autocapitalizationType = .none
            tf.autocorrectionType = .no
            tf.spellCheckingType = .no
            return tf
        }()
        
        let addFriendButton: UIButton = {
            let b = UIButton()
            b.setTitle(Text.AddFriend.localized(), for: .normal)
            b.setTitleColor(UIColor.white, for: .normal)
            b.backgroundColor = Colors.FidelityGreen!
            b.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            _ = b.reactive.tap.observeNext { (_) in
                if emailTextField.text?.isEmpty ?? false {
                    MessageHandler.shared.showMessageModal(theme: .error, title: Text.Error, body: Text.EmptyFieldError)
                    return
                }
                if let email = emailTextField.text  {
                    GradientLoadingBar.shared.fadeIn()
                    FirebaseService.shared.addFriend(email: email) { [unowned self] (error) in
                        GradientLoadingBar.shared.fadeOut()
                        if let error = error {
                            MessageHandler.shared.showMessageModal(theme: .error, title: Text.Failed, body: error.localizedDescription)
                        } else {
                            MessageHandler.shared.showMessageModal(theme: .success, title: Text.Success, body: Text.FriendRequestSent)
                            self.delegate?.fetchFriends()
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
            b.layer.cornerRadius = 5
            return b
        }()
        
        let stackView: UIStackView = {
            let v = UIStackView()
            v.axis = .vertical
            v.spacing = 20
            return v
        }()
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { (this) in
            this.leading.equalToSuperview().offset(20)
            this.trailing.equalToSuperview().offset(-20)
            this.height.lessThanOrEqualToSuperview().offset(-20)
            this.centerY.equalToSuperview()
        }
        
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(addFriendButton)
    }
    
}
