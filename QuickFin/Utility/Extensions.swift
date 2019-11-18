//
//  Extensions.swift
//  QuickFin
//
//  Created by Boyuan Xu on 11/15/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

extension UIViewController {
    
    func makeTextField(title: String, isSecure: Bool) -> SkyFloatingLabelTextField {
        let tf = SkyFloatingLabelTextField()
        tf.title = title.localized()
        tf.placeholder = title.localized()
        tf.errorColor = UIColor.red
        tf.textColor = Colors.DynamicTextColor
        tf.selectedTitleColor = Colors.FidelityGreen!
        tf.selectedLineColor = Colors.FidelityGreen!
        tf.isSecureTextEntry = isSecure
        return tf
    }
    
}
