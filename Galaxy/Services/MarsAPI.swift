//
//  MarsAPI.swift
//  Galaxy
//
//  Created by Marcos Kobuchi on 02/02/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation

class MarsAPI: API, MarsStoreProtocol {
    
    func fetchPhotos() -> (() throws -> [Photo]) {
        return {
            struct Photos: Codable {
                let photos: [Photo]
            }
            
            let photos: Photos = try self.request(request: Request.get(domain: "https://api.nasa.gov/", endpoint: "mars-photos/api/v1/rovers/curiosity/photos", parameters: ["earth_date": "2015-6-3"]))
            return photos.photos
        }
    }
    
}
