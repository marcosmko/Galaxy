//
//  DetailPhotoViewController.swift
//  Galaxy
//
//  Created by Marcos Kobuchi on 03/02/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import UIKit

protocol DetailPhotoDisplayLogic: class {
    func displayPhoto(viewModel: DetailPhoto.GetPhoto.ViewModel)
}

class DetailPhotoViewController: UIViewController, DetailPhotoDisplayLogic {
    
    var interactor: DetailPhotoInteractorProtocol?
    var router: DetailPhotoRouterProtocol?
    
    private func setup() {
        let viewController = self
        let interactor = DetailPhotoInteractor()
        let presenter = DetailPhotoPresenter()
        let router = DetailPhotoRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.dataStore = interactor
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func displayPhoto(viewModel: DetailPhoto.GetPhoto.ViewModel) {
        
    }
    
}
