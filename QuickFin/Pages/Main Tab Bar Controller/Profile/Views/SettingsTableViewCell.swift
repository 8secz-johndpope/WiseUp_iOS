//
//  SettingsTableViewCell.swift
//  QuickFin
//
//  Created by Boyuan Xu on 10/11/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import SnapKit

class SettingsTableViewCell: UITableViewCell {
    
    var icon: UIImageView = {
        let i = UIImageView(image: "🤔".emojiToImage())
        i.tintColor = Colors.DynamicTextColor
        return i
    }()
    
    var titleLabel: UILabel = {
        let l = UILabel()
        l.text = "--"
        l.textColor = Colors.DynamicTextColor
        return l
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension SettingsTableViewCell {
    
    func initUI() {
        addSubview(icon)
        icon.snp.makeConstraints { (this) in
            this.leading.equalToSuperview().offset(20)
            this.centerY.equalToSuperview()
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (this) in
            this.leading.equalTo(icon.snp.trailing).offset(10)
            this.centerY.equalTo(icon.snp.centerY)
        }
    }
    
}
