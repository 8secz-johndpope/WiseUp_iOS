//
//  LeaderboardTableViewCell.swift
//  QuickFin
//
//  Created by Boyuan Xu on 10/27/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import SnapKit

class LeaderboardTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        initUI()
    }
    
    let thumbnail: UIImageView = {
        let image = "?".emojiToImage()?.withAlignmentRectInsets(UIEdgeInsets(top: -5, left: -5, bottom: -5, right: -5))
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Elpson Fruth"
        l.textColor = Colors.DynamicTextColor
        l.font = UIFont.systemFont(ofSize: FontSizes.secondaryTitle)
        return l
    }()
    
    let scoreLabel: UILabel = {
        let l = UILabel()
        l.text = "0"
        l.textColor = Colors.DynamicTextColor
        l.font = UIFont.systemFont(ofSize: FontSizes.secondaryTitle)
        return l
    }()

}

extension LeaderboardTableViewCell {
    
    func initUI() {
        addSubview(thumbnail)
        thumbnail.snp.makeConstraints { (this) in
            this.leading.equalToSuperview().offset(20)
            this.centerY.equalToSuperview()
            this.height.equalTo(50)
            this.width.equalTo(50)
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (this) in
            this.leading.equalTo(thumbnail.snp.trailing).offset(10)
            this.centerY.equalToSuperview()
        }
        addSubview(scoreLabel)
        scoreLabel.snp.makeConstraints { (this) in
            this.trailing.equalToSuperview().offset(-20)
            this.centerY.equalToSuperview()
        }
    }
    
}
