//
//  ImageCell.swift
//  Galaxy
//
//  Created by Marcos Kobuchi on 03/02/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    func prepare(viewModel: Mars.FetchPhotos.ViewModel.DisplayedPhoto) {
        Media.download(path: viewModel.image, imageView: self.imageView)
    }
    
}
