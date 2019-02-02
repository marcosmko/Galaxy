//
//  MarsAPI.swift
//  Galaxy
//
//  Created by Marcos Kobuchi on 02/02/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation

var APIKEY: String = "khGhC8CtxrfEZa3ZQHN2XeSbDQ3kWIBEeFAjtRDn"

class MarsAPI: API, MarsStoreProtocol {
    
    func fetchPhotos() -> (() throws -> [Photo]) {
        return {
            struct Photos: Codable {
                let photos: [Photo]
            }
            
            let photos: Photos = try self.request(method: RequestMethod.get, url: "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?earth_date=2015-6-3&api_key=\(APIKEY)")
            return photos.photos
        }
    }
    
}
