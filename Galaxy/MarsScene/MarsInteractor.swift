//
//  MarsInteractor.swift
//  Galaxy
//
//  Created by Marcos Kobuchi on 02/02/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation

protocol MarsInteractorProtocol {
    func fetchPhotos(request: Mars.FetchPhotos.Request)
}

class MarsInteractor: MarsInteractorProtocol {
    var presenter: MarsPresenterProtocol?
    var marsWorker = MarsWorker(marsStore: MarsAPI())
    
    var photos: [Photo] = []
    private var requestID: UInt = 0
    
    func fetchPhotos(request: Mars.FetchPhotos.Request) {
        // we should display only last request
        let requestID: UInt = UInt.random(in: 0..<UInt.max)
        self.requestID = requestID
        
        DispatchQueue.global().async {
            do {
                self.photos = try self.marsWorker.fetchPhotos(rover: request.rover)
                let response = Mars.FetchPhotos.Response(photos: self.photos)
                
                DispatchQueue.main.async {
                    // check if we should display fetched rover
                    guard self.requestID == requestID else { return }
                    self.presenter?.presentFetchedOrders(response: response)
                }
            } catch {
                // show error
                print(error.localizedDescription)
            }
        }
    }
    
}
