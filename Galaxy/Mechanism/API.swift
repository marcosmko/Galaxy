//
//  API.swift
//  Galaxy
//
//  Created by Marcos Kobuchi on 02/02/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation

/// The request method, based on HTTP methods.
public enum RequestMethod : String {
    /// Delete method, used to delete information.
    case delete = "DELETE"
    
    /// Get method, used to return information.
    case get = "GET"
    
    /// Patch method, used to change information.
    case patch = "PATCH"
    
    /// Post method, used for create new information.
    case post = "POST"
}


class API {
    
    private static func createRequest(method: RequestMethod, url: URL, data: Data?) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 120)
        
        request.httpShouldHandleCookies = false
        request.httpShouldUsePipelining = true
        request.httpMethod = method.rawValue
        
        if let data = data {
            request.httpBody = data
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
    
    public func request<T: Codable>(method: RequestMethod, url: String, data: Data? = nil) throws -> T {
        let data: Data = try self.request(method: method, url: url, data: data)
        
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    public func request(method: RequestMethod, url: String, data: Data? = nil) throws -> Data {
        guard let url = URL(string: url) else {
            fatalError()
        }
        
        let urlRequest: URLRequest = API.createRequest(method: method, url: url, data: data)
        let (data, response, error) = API.process(request: urlRequest)
        
        if let response = response {
            if 200 <= response.statusCode && response.statusCode < 300, let data: Data = data {
                return data
            } else {
                fatalError()
            }
        }
        
        if let error = error as NSError? {
            throw error
        } else {
            fatalError()
        }
    }
    
    private static func process(request: URLRequest) -> (Data?, HTTPURLResponse?, Error?) {
        #if DEBUG
        let startTime = CFAbsoluteTimeGetCurrent()
        API.printLog(request: request)
        #endif
        
        let session: URLSession = URLSession(configuration: .default)
        let (data, response, error) = session.performSynchronousRequest(request)
        
        #if DEBUG
        if let url = request.url {
            API.printLog(response: response, url: url, startTime: startTime, data: data)
        }
        #endif
        
        return (data, response, error)
    }

}

#if DEBUG
extension API {
    
    private static func printLog(request: URLRequest) {
        let components = NSURLComponents(string: request.url?.absoluteString ?? "")
        var message = "\n----------------------------------\n\(request.httpMethod ?? "") \(components?.path ?? "")?\(components?.query ?? "") HTTP/1.1\nHost: \(components?.host ?? "")\n"
        
        for (name, value) in request.allHTTPHeaderFields ?? [:] {
            message += "\(name): \(value)\n"
        }
        
        if let string = request.httpBody?.stringValue {
            message += "\(string)\n"
        }
        
        print("\(message)----------------------------------\n")
    }
    
    private static func printLog(response: URLResponse?, url: URL, startTime: CFAbsoluteTime, data: Data?) {
        var message = "\n----------------------------------\nResponse: \(url.absoluteString)\n\((CFAbsoluteTimeGetCurrent() - startTime).humanReadable)\n\n"
        
        if let response = response as? HTTPURLResponse {
            for (name, value) in response.allHeaderFields {
                message += "\(name): \(value)\n"
            }
            
            if let string = data?.stringValue {
                message += "\(string)\n"
            }
        }
        
        print("\(message)----------------------------------\n")
    }
    
}

/// The data extensions.
public extension Data {
    /// Get the string of string data.
    public var stringValue: String? {
        if let  object = try? JSONSerialization.jsonObject(with: self, options: .allowFragments),
            let string = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .sortedKeys]) {
            return String(data: string, encoding: .utf8)
        }
        return String(data: self, encoding: .utf8)
    }
    
    @inline(__always) mutating func append(string: String?) {
        if let data = string?.data(using: .utf8, allowLossyConversion: false) {
            append(data)
        }
    }
}

extension CFAbsoluteTime {
    var humanReadable: String {
        var suffix = "s"
        var time = self
        
        if time > 100 {
            suffix = "m"
            time /= 60
        } else if time < 1e-6 {
            suffix = "ns"
            time *= 1e9
        } else if time < 1e-3 {
            suffix = "µs"
            time *= 1e6
        } else if time < 1 {
            suffix = "ms"
            time *= 1000
        }
        
        return "\(String(format: "%.2f", time))\(suffix)"
    }
}
#endif
