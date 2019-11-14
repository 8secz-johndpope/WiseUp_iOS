//
//  Core.swift
//  QuickFin
//
//  Created by Boyuan Xu on 9/22/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import Foundation

class Core: Codable {
    
    static var shared = Core()
    private init() {}
    
    var coldStart = true
    
    
}

