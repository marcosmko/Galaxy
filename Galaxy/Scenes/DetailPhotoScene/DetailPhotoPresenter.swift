//
//  DetailPhotoPresenter.swift
//  Galaxy
//
//  Created by Marcos Kobuchi on 03/02/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation

protocol DetailPhotoPresenterProtocol {
    func presentPhoto(response: DetailPhoto.GetPhoto.Response)
}

class DetailPhotoPresenter: DetailPhotoPresenterProtocol {
    weak var viewController: DetailPhotoDisplayLogic?
    
    func presentPhoto(response: DetailPhoto.GetPhoto.Response) {
        let photo = response.photo
        
        guard let image = photo.imgSrc else {
            return
        }
        
        let displayedPhoto = DetailPhoto.GetPhoto.DisplayedPhotoViewModel.DisplayedPhoto(image: image)
        let viewModel = DetailPhoto.GetPhoto.DisplayedPhotoViewModel(displayedPhoto: displayedPhoto)
        viewController?.displayPhoto(viewModel: viewModel)
    }
}
