//
//  Images.swift
//  QuickFin
//
//  Created by Boyuan Xu on 9/29/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit

struct Images {
    static let chaptersUnselected = #imageLiteral(resourceName: "Chapters Unselected")
    static let chapters = #imageLiteral(resourceName: "Chapters")
    static let leaderboardUnselected = #imageLiteral(resourceName: "Leaderboard Unselected")
    static let leaderboard = #imageLiteral(resourceName: "Leaderboard")
    static let profileUnselected = #imageLiteral(resourceName: "Profile Unselected")
    static let profile = #imageLiteral(resourceName: "Profile")
    static let storeUnselected = #imageLiteral(resourceName: "Store Unselected")
    static let store = #imageLiteral(resourceName: "Store")
    static let userPlaceholder = #imageLiteral(resourceName: "Blank User Icon")
}

extension String {
    func emojiToImage() -> UIImage? {
        let size = CGSize(width: 30, height: 35)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()
        let rect = CGRect(origin: CGPoint(), size: size)
        UIRectFill(CGRect(origin: CGPoint(), size: size))
        (self as NSString).draw(in: rect, withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
