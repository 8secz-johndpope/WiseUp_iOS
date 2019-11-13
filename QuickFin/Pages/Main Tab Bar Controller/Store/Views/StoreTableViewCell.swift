//
//  StoreTableViewCell.swift
//  QuickFin
//
//  Created by Boyuan Xu on 10/28/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import SnapKit

class StoreTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    let thumbnail: UIImageView = {
        let image = "🤔".emojiToImage()?.withAlignmentRectInsets(UIEdgeInsets(top: -5, left: -5, bottom: -5, right: -5))
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
    
    let numberLabel: UILabel = {
        let l = UILabel()
        l.text = "0"
        l.textColor = Colors.DynamicTextColor
        l.font = UIFont.systemFont(ofSize: FontSizes.secondaryTitle)
        return l
    }()
    
    let descriptionLabel: UILabel = {
        let l = UILabel()
        l.text = "Elpson Fruth"
        l.textColor = Colors.DynamicTextColor
        l.font = UIFont.systemFont(ofSize: FontSizes.text)
        l.numberOfLines = 1
        l.alpha = 0.7
        return l
    }()

}

extension StoreTableViewCell {
    
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
            this.bottom.equalTo(snp.centerY)
        }
        addSubview(numberLabel)
        numberLabel.snp.makeConstraints { (this) in
            this.trailing.equalToSuperview().offset(-20)
            this.centerY.equalToSuperview()
        }
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (this) in
            this.leading.equalTo(titleLabel.snp.leading)
            this.top.equalTo(titleLabel.snp.bottom)
            this.trailing.equalTo(numberLabel.snp.leading).offset(-10)
        }
    }
    
}
