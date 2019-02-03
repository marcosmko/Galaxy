//
//  MarsPresenter.swift
//  Galaxy
//
//  Created by Marcos Kobuchi on 02/02/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation

protocol MarsPresenterProtocol {
    func presentFetchedOrders(response: Mars.FetchPhotos.Response)
}

class MarsPresenter: MarsPresenterProtocol {
    weak var viewController: MarsDisplayLogic?
    func presentFetchedOrders(response: Mars.FetchPhotos.Response) {
        var displayedPhotos: [Mars.FetchPhotos.ViewModel.DisplayedPhoto] = []
        for photo in response.photos {
            let displayedPhoto = Mars.FetchPhotos.ViewModel.DisplayedPhoto()
            displayedPhotos.append(displayedPhoto)
        }
        let viewModel = Mars.FetchPhotos.ViewModel(displayedPhotos: displayedPhotos)
        viewController?.displayFetchedPhotos(viewModel: viewModel)
    }
}
