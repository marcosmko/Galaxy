//
//  DetailPhotoViewController.swift
//  Galaxy
//
//  Created by Marcos Kobuchi on 03/02/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import UIKit

protocol DetailPhotoDisplayLogic: class {
    func displayPhoto(viewModel: DetailPhoto.GetPhoto.DisplayedPhotoViewModel)
    func displayName(viewModel: DetailPhoto.GetPhoto.DisplayedNameViewModel)
}

class DetailPhotoViewController: UIViewController, DetailPhotoDisplayLogic {
    
    @IBOutlet private var cameraNameButton: UIButton!
    @IBOutlet private var imageView: UIImageView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactor?.getPhoto(request: DetailPhoto.GetPhoto.Request())
    }
    
    func displayPhoto(viewModel: DetailPhoto.GetPhoto.DisplayedPhotoViewModel) {
        Media.download(path: viewModel.displayedPhoto.image, imageView: self.imageView)
    }
    
    func displayName(viewModel: DetailPhoto.GetPhoto.DisplayedNameViewModel) {
        self.cameraNameButton.setTitle(viewModel.displayedPhoto.camera, for: .normal)
    }
    
}
