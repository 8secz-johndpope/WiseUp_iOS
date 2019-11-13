//
//  CustomTableViewCell.swift
//  QuickFin
//
//  Created by Kevin Yeung on 10/23/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit

//code for each individual cell in the tableView
class CustomTableViewCell: UITableViewCell {
    
    lazy var backView: UIView = {
        let view = UIView(frame: CGRect(x: 10, y: 6, width: self.frame.width+75, height: 110) )
        view.backgroundColor = UIColor.clear
        return view
    } ()
    
    lazy var userImage: UIImageView = {
        let userImage = UIImageView(frame: CGRect(x: 4, y: 6, width: 102, height: 102))
        userImage.contentMode = .scaleAspectFill
        return userImage
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 116, y: 8, width: backView.frame.width - 116, height: 30))
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.black
        return label
    }()
    
    lazy var trophyImage: UIImageView = {
        let trophyImage = UIImageView(frame: CGRect(x: 236, y: 28, width: 62, height: 62))
        trophyImage.contentMode = .scaleAspectFill
        return trophyImage
    }()
    
    lazy var trophyCount: UILabel = {
        let label = UILabel(frame: CGRect(x: 306, y: 38, width: backView.frame.width - 116, height: 30))
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.brown
        return label
    }()

    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        backView.layer.cornerRadius = 5
        backView.clipsToBounds = true
        userImage.layer.cornerRadius = 51 //102/2 (dimension of userImage/2)
        userImage.clipsToBounds = true
        trophyImage.layer.cornerRadius = 31
        trophyImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addSubview(backView)
        backView.addSubview(userImage)
        backView.addSubview(nameLabel)
        backView.addSubview(trophyImage)
        backView.addSubview(trophyCount)
    }

}



