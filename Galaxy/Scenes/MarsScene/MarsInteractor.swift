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

protocol MarsDataStore {
    var photos: [Photo] { get }
}

class MarsInteractor: MarsInteractorProtocol, MarsDataStore {
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
                // clean screen while we are fetching photos
                DispatchQueue.main.sync {
                    let response = Mars.FetchPhotos.Response(photos: [])
                    self.presenter?.presentFetchedOrders(response: response)
                }
                
                // this could run for some time
                var photos: [Photo] = []
                var date: Date = Date()
                while photos.isEmpty {
                    guard self.requestID == requestID else { return }
                    photos = try self.marsWorker.fetchPhotos(rover: request.rover, date: date)
                    
                    // one month before
                    date.addTimeInterval(-30*24*60*60)
                }
                let response = Mars.FetchPhotos.Response(photos: photos)
                
                // check if we are still with the same request
                guard self.requestID == requestID else { return }
                self.photos = photos
                DispatchQueue.main.sync {
                    self.presenter?.presentFetchedOrders(response: response)
                }
            } catch {
                // show error
                print(error.localizedDescription)
            }
        }
    }
    
}
