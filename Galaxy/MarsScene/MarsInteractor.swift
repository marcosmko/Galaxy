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
    
    func fetchPhotos(request: Mars.FetchPhotos.Request) {
        DispatchQueue.global().async {
            do {
                self.photos = try self.marsWorker.fetchPhotos()
                let response = Mars.FetchPhotos.Response(photos: self.photos)
                
                DispatchQueue.main.async {
                    self.presenter?.presentFetchedOrders(response: response)
                }
            } catch {
                // show error
                print(error.localizedDescription)
            }
        }
    }
    
}
