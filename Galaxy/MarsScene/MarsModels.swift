//
//  MarsModels.swift
//  Galaxy
//
//  Created by Marcos Kobuchi on 02/02/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation

enum Mars {
    
    enum FetchPhotos {
        struct Request { }
        struct Response {
            var photos: [Photo]
        }
        struct ViewModel {
            struct DisplayedPhoto {
//                var id: String
//                var date: String
//                var email: String
//                var name: String
//                var total: String
            }
            var displayedPhotos: [DisplayedPhoto]
        }
    }
    
}
