//
//  ViewController.swift
//  Galaxy
//
//  Created by Marcos Kobuchi on 02/02/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import UIKit

class MarsViewController: UIViewController {
    var interactor: MarsInteractorProtocol?
    var router: MarsRouterProtocol?
    var items: [Int] = [0]
    
    private func setup() {
        let viewController = self
        let interactor = MarsInteractor()
        let presenter = MarsPresenter()
        let router = MarsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        // router.dataStore = interactor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.fetchPhotos()
    }
    
    private func fetchPhotos() {
        self.interactor?.fetchPhotos(request: Mars.FetchPhotos.Request())
    }
    
}

extension MarsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width/2
        return CGSize(width: width, height: width)
    }
    
}
