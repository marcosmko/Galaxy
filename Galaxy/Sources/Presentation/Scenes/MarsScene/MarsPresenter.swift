//
//  MarsPresenter.swift
//  Galaxy
//
//  Created by Marcos Kobuchi on 02/02/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation

protocol MarsPresenterProtocol {
    func present(response: Mars.FetchPhotos.Response)
}

class MarsPresenter: MarsPresenterProtocol {
    weak var viewController: MarsDisplayLogic?
    
    func present(response: Mars.FetchPhotos.Response) {
        let blockForExecutionInMainThread: BlockOperation = BlockOperation(block: {
            var displayedPhotos: [Mars.FetchPhotos.ViewModel.DisplayedPhoto] = []
            for photo in response.photos {
                guard let image = photo.imgSrc else { continue }
                let displayedPhoto = Mars.FetchPhotos.ViewModel.DisplayedPhoto(image: image)
                displayedPhotos.append(displayedPhoto)
            }
            let viewModel = Mars.FetchPhotos.ViewModel(displayedPhotos: displayedPhotos)
            self.viewController?.display(viewModel: viewModel)
        })
        
        QueueManager.shared.executeBlock(blockForExecutionInMainThread, queueType: .main)
    }
    
}
