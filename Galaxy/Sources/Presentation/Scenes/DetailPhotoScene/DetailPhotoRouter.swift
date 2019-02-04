//
//  DetailPhotoRouter.swift
//  Galaxy
//
//  Created by Marcos Kobuchi on 03/02/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation

@objc
protocol DetailPhotoRouting: class {
    
}

protocol DetailPhotoRouterProtocol: NSObjectProtocol {
    var dataStore: DetailPhotoDataStore? { get }
}

class DetailPhotoRouter: NSObject, DetailPhotoRouterProtocol, DetailPhotoRouting {
    var dataStore: DetailPhotoDataStore?
}
