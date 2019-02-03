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
        struct ViewModel {
            struct DisplayedPhoto {
                let image: String
            }
            let displayedPhoto: DisplayedPhoto
        }
    }
    
    enum GetName {
        struct Request {
        }
        struct Response {
            let name: String
        }
        struct ViewModel {
            struct DisplayedName {
                let camera: String
            }
            let displayedPhoto: DisplayedName
        }
    }
    
}
