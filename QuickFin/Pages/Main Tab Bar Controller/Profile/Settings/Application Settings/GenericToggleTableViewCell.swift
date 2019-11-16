//
//  GenericToggleTableViewCell.swift
//  QuickFin
//
//  Created by Boyuan Xu on 11/15/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import SnapKit

class GenericToggleTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    var leftLabel: UILabel!
    var rightToggle: UISwitch!
}

// MARK: - UI
extension GenericToggleTableViewCell {
    
    func initUI() {
        leftLabel = {
            let l = UILabel()
            l.textColor = Colors.DynamicTextColor
            l.numberOfLines = 0
            return l
        }()
        rightToggle = {
            let s = UISwitch()
            s.onTintColor = Colors.FidelityGreen
            return s
        }()
        
        addSubview(leftLabel)
        addSubview(rightToggle)
        rightToggle.snp.makeConstraints { (this) in
            this.centerY.equalToSuperview()
            this.trailing.equalToSuperview().offset(-20)
        }
        leftLabel.snp.makeConstraints { (this) in
            this.centerY.equalToSuperview()
            this.leading.equalToSuperview().offset(20)
            this.trailing.equalTo(rightToggle.snp.leading).offset(-20)
        }
    }
    
}
