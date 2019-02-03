//
//  MarsWorker.swift
//  Galaxy
//
//  Created by Marcos Kobuchi on 02/02/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation

class MarsWorker {
    var marsStore: MarsStoreProtocol
    
    init(marsStore: MarsStoreProtocol) {
        self.marsStore = marsStore
    }
    
    func fetchPhotos(rover: MarsRover) throws -> [Photo] {
        return try marsStore.fetchPhotos()(rover)
    }
}

// MARK: - Orders store API

protocol MarsStoreProtocol {
    func fetchPhotos() -> ((_ rover: MarsRover) throws -> [Photo])
}
