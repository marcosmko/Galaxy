//
//  MarsRouter.swift
//  Galaxy
//
//  Created by Marcos Kobuchi on 02/02/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation
import UIKit.UIStoryboardSegue

@objc
protocol MarsRouting: class {
    func routeToShowDetail(segue: UIStoryboardSegue, sender: Any?)
}

protocol MarsRouterProtocol: NSObjectProtocol {
    var dataStore: MarsDataStore? { get }
}

class MarsRouter: NSObject, MarsRouterProtocol, MarsRouting {
    var dataStore: MarsDataStore?
    
    func routeToShowDetail(segue: UIStoryboardSegue, sender: Any?) {
        guard let dataStore = self.dataStore,
            let destinationVC = segue.destination as? DetailPhotoViewController,
            var destinationDS = destinationVC.router?.dataStore else {
                return
        }
        self.passDataToShowDetail(source: dataStore, destination: &destinationDS, sender: sender)
    }
    
    // MARK: Passing data
    
    private func passDataToShowDetail(source: MarsDataStore, destination: inout DetailPhotoDataStore, sender: Any?) {
        guard let item: Int = sender as? Int else { return }
        destination.photo = source.photos[item]
    }

}
