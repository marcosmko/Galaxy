//
//  MarsAPI.swift
//  Galaxy
//
//  Created by Marcos Kobuchi on 02/02/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation

class MarsAPI: API, MarsStoreProtocol {
    
    func fetchPhotos() -> ((_ rover: MarsRover, _ date: Date) throws -> [Photo]) {
        return { rover, date in
            struct Photos: Codable {
                let photos: [Photo]
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            let photos: Photos = try API.request(request: Request.get(domain: "https://api.nasa.gov/", endpoint: "mars-photos/api/v1/rovers/\(rover.api())/photos", parameters: ["earth_date": formatter.string(from: date)]))
            return photos.photos
        }
    }
    
}
