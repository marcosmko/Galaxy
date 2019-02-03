//
//  MarsRouter.swift
//  Galaxy
//
//  Created by Marcos Kobuchi on 02/02/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation

protocol MarsRouting: class {
}

protocol MarsRouterProtocol {
    
}

class MarsRouter: MarsRouterProtocol, MarsRouting {
    weak var viewController: MarsViewController?
}
