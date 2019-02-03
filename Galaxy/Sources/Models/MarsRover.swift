//
//  MarsRover.swift
//  Galaxy
//
//  Created by Marcos Kobuchi on 03/02/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation

enum MarsRover {
    case curiosity
    case opportunity
    case spirit
}

extension MarsRover {
    
    func api() -> String {
        switch self {
        case .curiosity:
            return "curiosity"
        case .opportunity:
            return "opportunity"
        case .spirit:
            return "spirit"
        }
    }
    
}
