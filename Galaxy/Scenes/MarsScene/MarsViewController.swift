//
//  ViewController.swift
//  Galaxy
//
//  Created by Marcos Kobuchi on 02/02/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import UIKit

protocol MarsDisplayLogic: class {
    func displayFetchedPhotos(viewModel: Mars.FetchPhotos.ViewModel)
}

class MarsViewController: UIViewController, MarsDisplayLogic {
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var segmentedControl: UISegmentedControl!
    
    var interactor: MarsInteractorProtocol?
    var router: MarsRouterProtocol?
    var displayedPhotos: [Mars.FetchPhotos.ViewModel.DisplayedPhoto] = []
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.fetchPhotos()
    }
    
    @IBAction private func segmentValueChanged(_ sender: Any) {
        self.fetchPhotos()
    }
    
    private func fetchPhotos() {
        let rover: MarsRover
        switch self.segmentedControl.selectedSegmentIndex {
        case 1: rover = .opportunity
        case 2: rover = .spirit
        default: rover = .curiosity
        }
        self.interactor?.fetchPhotos(request: Mars.FetchPhotos.Request(rover: rover))
    }
    
    func displayFetchedPhotos(viewModel: Mars.FetchPhotos.ViewModel) {
        self.displayedPhotos = viewModel.displayedPhotos
        self.collectionView.reloadData()
    }
    
}

extension MarsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ImageCell else {
            return UICollectionViewCell()
        }
        let viewModel = self.displayedPhotos[indexPath.row]
        cell.prepare(viewModel: viewModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize.zero
        }
        
        let width = (UIScreen.main.bounds.width - flowLayout.minimumInteritemSpacing - flowLayout.sectionInset.left - flowLayout.sectionInset.right) / 2
        return CGSize(width: width, height: width)
    }
    
}
