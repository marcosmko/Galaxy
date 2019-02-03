//
//  DetailPhotoInteractor.swift
//  Galaxy
//
//  Created by Marcos Kobuchi on 03/02/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation

protocol DetailPhotoInteractorProtocol {
    func getPhoto(request: DetailPhoto.GetPhoto.Request)
}

protocol DetailPhotoDataStore {
    var photo: Photo! { get set }
}

class DetailPhotoInteractor: DetailPhotoInteractorProtocol, DetailPhotoDataStore {
    var presenter: DetailPhotoPresenterProtocol?
    var photo: Photo!
    
    // MARK: - Fetch order
    
    func getPhoto(request: DetailPhoto.GetPhoto.Request) {
        DispatchQueue.global().async {
            let response = DetailPhoto.GetPhoto.Response(photo: self.photo)
            self.presenter?.presentPhoto(response: response)
        }
    }
    
}
