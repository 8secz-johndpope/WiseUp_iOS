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
        l.numberOfLines = 0
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
        if selected {
            tappped(correct: isCorrect)
        }
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
            titleLabel.font = .boldSystemFont(ofSize: FontSizes.pageTitle)
            layer.shadowColor = Colors.FidelityGreen?.cgColor
            layer.shadowRadius = 15
            layer.shadowOpacity = 1
        } else {
            backgroundColor = UIColor.red
            layer.shadowColor = UIColor.red.cgColor
            alpha = 0.3
        }
    }
    
}
