//
//  SignInDelegateProtocol.swift
//  QuickFin
//
//  Created by Boyuan Xu on 9/22/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import Foundation

protocol SignInDelegate: class {
    func didSignUp(email: String, password: String)
}
