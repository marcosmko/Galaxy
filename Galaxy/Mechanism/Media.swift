//
//  Media.swift
//  Galaxy
//
//  Created by Marcos Kobuchi on 03/02/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation
import UIKit.UIImage
import UIKit.UIImageView

class Media {
    
    static func download(path: String, imageView: UIImageView) {
        DispatchQueue.global().async {
            guard let data: Data = try? API.request(request: Request.get(path: path)) else {
                return
            }
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        }
    }
    
}
