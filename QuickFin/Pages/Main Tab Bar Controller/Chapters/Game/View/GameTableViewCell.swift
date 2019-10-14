//
//  GameTableViewCell.swift
//  QuickFin
//
//  Created by Boyuan Xu on 10/14/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import SnapKit

class GameTableViewCell: UITableViewCell {
    
    var isCorrect = false
    
    var titleLabel: UILabel = {
        let l = UILabel()
        l.text = "--"
        l.textColor = .white
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
        tappped(correct: isCorrect)
    }

}

extension GameTableViewCell {
    
    func initUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (this) in
            this.center.equalToSuperview()
        }
        
        backgroundColor = Colors.FidelityGreen
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowOpacity = 0.5
        layer.cornerRadius = 2
        layer.masksToBounds = false
    }
    
    func tappped(correct: Bool) {
        if correct {
            backgroundColor = UIColor.systemBackground
            titleLabel.textColor = Colors.FidelityGreen
            layer.shadowColor = Colors.FidelityGreen?.cgColor
        } else {
            backgroundColor = UIColor.red
            layer.shadowColor = UIColor.red.cgColor
        }
    }
    
}
