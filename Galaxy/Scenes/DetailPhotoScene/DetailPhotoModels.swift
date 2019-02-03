//
//  DetailPhotoModels.swift
//  Galaxy
//
//  Created by Marcos Kobuchi on 03/02/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation

enum DetailPhoto {
    
    enum GetPhoto {
        struct Request {
        }
        struct Response {
            let photo: Photo
        }
        struct DisplayedPhotoViewModel {
            struct DisplayedPhoto {
                let image: String
            }
            let displayedPhoto: DisplayedPhoto
        }
        struct DisplayedNameViewModel {
            struct DisplayedName {
                let camera: String
            }
            let displayedPhoto: DisplayedName
        }
    }
    
}
