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
    
    private static var associated: [UIImageView: String] = [:]
    
    static func download(path: String, imageView: UIImageView) {
        DispatchQueue.global().async {
            self.associated[imageView] = path
            var image: UIImage?
            do {
                let data: Data = try API.request(request: Request.get(path: path))
                image = UIImage(data: data)
            } catch {
            }
            
            if self.associated[imageView] == path {
                self.associated[imageView] = nil
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
    }
    
}
