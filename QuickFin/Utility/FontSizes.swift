//
//  Fonts.swift
//  QuickFin
//
//  Created by Boyuan Xu on 9/21/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit

struct FontSizes {
    static let largeNavTitle: CGFloat = 34
    static let navTitle: CGFloat = 17
    static let pageTitle: CGFloat = 17
    static let secondaryTitle: CGFloat = 15
    static let text: CGFloat = 13
    static let tableHeader: CGFloat = 13
    static let tabBarTitle: CGFloat = 10
}

extension UILabel{
    func requiredHeight(width: CGFloat) -> CGFloat {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = font
        lbl.text = text
        let height = lbl.systemLayoutSizeFitting(CGSize(width: width, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
        return height
    }
}
