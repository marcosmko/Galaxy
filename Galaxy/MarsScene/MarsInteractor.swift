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
    
    func fetchPhotos(request: Mars.FetchPhotos.Request) {
        DispatchQueue.global().async {
            do {
                let photos = try self.marsWorker.fetchPhotos()
            } catch {
                print(error.localizedDescription)
            }
        }
        
//        ordersWorker.fetchOrders { (orders) -> Void in
//            self.orders = orders
//            let response = ListOrders.FetchOrders.Response(orders: orders)
//            self.presenter?.presentFetchedOrders(response: response)
//        }
    }
    
}
