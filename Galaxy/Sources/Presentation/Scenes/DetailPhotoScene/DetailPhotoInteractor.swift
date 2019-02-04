//
//  DetailPhotoInteractor.swift
//  Galaxy
//
//  Created by Marcos Kobuchi on 03/02/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation

protocol DetailPhotoInteractorProtocol {
    func get(request: DetailPhoto.GetPhoto.Request)
    func get(request: DetailPhoto.GetName.Request)
}

protocol DetailPhotoDataStore {
    var photo: Photo? { get set }
}

class DetailPhotoInteractor: DetailPhotoInteractorProtocol, DetailPhotoDataStore {
    var presenter: DetailPhotoPresenterProtocol?
    var photo: Photo?
    
    private var fullName: Bool = true
    
    func get(request: DetailPhoto.GetPhoto.Request) {
        let blockForExecutionInBackground: BlockOperation = BlockOperation(block: {
            guard let photo = self.photo else { return }
            let response = DetailPhoto.GetPhoto.Response(photo: photo)
            self.presenter?.present(response: response)
        })
        
        QueueManager.shared.executeBlock(blockForExecutionInBackground, queueType: .concurrent)
    }
    
    func get(request: DetailPhoto.GetName.Request) {
        let blockForExecutionInBackground: BlockOperation = BlockOperation(block: {
            self.fullName.toggle()
            let name: String = (self.fullName ? self.photo?.camera?.fullName : self.photo?.camera?.name) ?? ""
            let response = DetailPhoto.GetName.Response(name: name)
            self.presenter?.present(response: response)
        })
        
        QueueManager.shared.executeBlock(blockForExecutionInBackground, queueType: .concurrent)
    }
    
}
