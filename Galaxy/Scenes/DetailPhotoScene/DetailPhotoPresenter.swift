//
//  DetailPhotoPresenter.swift
//  Galaxy
//
//  Created by Marcos Kobuchi on 03/02/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation

protocol DetailPhotoPresenterProtocol {
    func present(response: DetailPhoto.GetPhoto.Response)
    func present(response: DetailPhoto.GetName.Response)
}

class DetailPhotoPresenter: DetailPhotoPresenterProtocol {
    weak var viewController: DetailPhotoDisplayLogic?
    
    func present(response: DetailPhoto.GetPhoto.Response) {
        DispatchQueue.main.async {
            let photo = response.photo
            
            guard let image = photo.imgSrc else {
                return
            }
            
            let displayedPhoto = DetailPhoto.GetPhoto.ViewModel.DisplayedPhoto(image: image)
            let viewModel = DetailPhoto.GetPhoto.ViewModel(displayedPhoto: displayedPhoto)
            self.viewController?.display(viewModel: viewModel)
        }
    }
    
    func present(response: DetailPhoto.GetName.Response) {
        DispatchQueue.main.async {
            let photo = response.name
            let displayedName = DetailPhoto.GetName.ViewModel.DisplayedName(camera: photo)
            let viewModel = DetailPhoto.GetName.ViewModel(displayedPhoto: displayedName)
            self.viewController?.display(viewModel: viewModel)
        }
    }
}
