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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let router = self.router, let identifier = segue.identifier else { return }
        let selector = NSSelectorFromString("routeTo\(identifier)WithSegue:sender:")
        if router.responds(to: selector) {
            router.perform(selector, with: segue, with: sender)
        }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowDetail", sender: indexPath.row)
    }
    
}
