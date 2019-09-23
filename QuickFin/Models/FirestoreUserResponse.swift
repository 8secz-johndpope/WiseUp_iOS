//
//  FirestoreResponse.swift
//  QuickFin
//
//  Created by Boyuan Xu on 9/23/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import Foundation

struct FirestoreUserResponse {
    var user: User?
    var error: Error?
    
    init(user: User? = nil, error: Error? = nil) {
        self.user = user
        self.error = error
    }
}
