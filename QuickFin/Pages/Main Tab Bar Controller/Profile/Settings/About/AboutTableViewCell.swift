//
//  AboutTableViewCell.swift
//  QuickFin
//
//  Created by Boyuan Xu on 11/14/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import SnapKit

class AboutTableViewCell: UITableViewCell {

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    var leftLabel: UILabel!
    var rightLabel: UILabel!

}

// MARK: - UI
extension AboutTableViewCell {
    
    func initUI() {
        leftLabel = makeLabel()
        rightLabel = makeLabel()
        
        addSubview(leftLabel)
        addSubview(rightLabel)
        rightLabel.snp.makeConstraints { (this) in
            this.trailing.equalToSuperview().offset(-10)
            this.centerY.equalToSuperview()
        }
        leftLabel.snp.makeConstraints { (this) in
            this.leading.equalToSuperview().offset(10)
            this.centerY.equalToSuperview()
            this.trailing.equalTo(rightLabel.snp.leading).offset(-10)
        }
    }
    
    private func makeLabel() -> UILabel {
        return {
            let l = UILabel()
            l.numberOfLines = 1
            l.textColor = Colors.DynamicTextColor
            return l
        }()
    }
}
