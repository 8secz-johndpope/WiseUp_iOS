//
//  FriendsTableViewCell.swift
//  QuickFin
//
//  Created by Boyuan Xu on 1/18/20.
//  Copyright © 2020 Fidelity Investments. All rights reserved.
//

import UIKit
import SwipeCellKit
import SnapKit

protocol FriendsTableViewCellDelegate: class {
    func deleteFriend(index: Int)
}

class FriendsTableViewCell: SwipeTableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    weak var customViewCellSwipeDelegate: FriendsTableViewCellDelegate?
    var profileImageView = UIImageView(image: Images.userPlaceholder)
    var usernameLabel: UILabel = {
        let l = UILabel()
        l.text = Text.Placeholder
        l.textColor = Colors.DynamicTextColor
        l.numberOfLines = 1
        return l
    }()
    
    private func initUI() {
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { (this) in
            this.leading.equalToSuperview().offset(20)
            this.centerY.equalToSuperview()
            this.width.equalTo(50)
            this.height.equalTo(50)
        }
        addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { (this) in
            this.leading.equalTo(profileImageView.snp.trailing).offset(20)
            this.centerY.equalToSuperview()
            this.trailing.equalToSuperview().offset(-20)
        }
    }
    
}
