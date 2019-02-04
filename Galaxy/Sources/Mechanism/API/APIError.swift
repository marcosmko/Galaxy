//
//  APIError.swift
//  Galaxy
//
//  Created by Marcos Kobuchi on 04/02/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation

enum APIError: Error {
    case malformedURL
    case noContent
    case error(httpCode: Int, payload: Data?)
}
