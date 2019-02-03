//
//  API.swift
//  Galaxy
//
//  Created by Marcos Kobuchi on 02/02/19.
//  Copyright © 2019 Marcos Kobuchi. All rights reserved.
//

import Foundation

class Request {
    let method: RequestMethod
    let domain: String
    let endpoint: String
    let parameters: [String: String]
    let data: Data?
    
    var url: URL?
    static func get(domain: String, endpoint: String, parameters: [String: String] = [:]) -> Request {
        return Request(method: .get,
                       domain: domain,
                       endpoint: endpoint,
                       parameters: parameters)
    }
    
    static func get(path: String, parameters: [String: String] = [:]) -> Request {
        return Request(method: .get,
                       domain: path,
                       endpoint: "",
                       parameters: parameters)
    }
    
    private init(method: RequestMethod, domain: String, endpoint: String, parameters: [String: String]) {
        self.method = method
        self.domain = domain
        self.endpoint = endpoint
        self.parameters = parameters
        self.data = nil
    }
    
}

/// The request method, based on HTTP methods.
public enum RequestMethod: String {
    /// Delete method, used to delete information.
    case delete = "DELETE"
    
    /// Get method, used to return information.
    case get = "GET"
    
    /// Patch method, used to change information.
    case patch = "PATCH"
    
    /// Post method, used for create new information.
    case post = "POST"
}

enum APIError: Error {
    case malformedURL
    case error(httpCode: Int, payload: Data?)
}

class API {
    
    private static func create(request: Request, data: Data?) throws -> URLRequest {
        guard let url = URL(string: "\(request.domain)\(request.endpoint)") else {
            throw APIError.malformedURL
        }
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw APIError.malformedURL
        }
        
        var queryItems: [URLQueryItem] = [URLQueryItem(name: "api_key", value: "khGhC8CtxrfEZa3ZQHN2XeSbDQ3kWIBEeFAjtRDn")]
        for parameter in request.parameters {
            queryItems.append(URLQueryItem(name: parameter.key, value: parameter.value))
        }
        components.queryItems = queryItems
        
        guard let urlWithComponents = components.url else {
            throw APIError.malformedURL
        }
        var urlRequest = URLRequest(url: urlWithComponents, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 120)
        urlRequest.httpShouldHandleCookies = false
        urlRequest.httpShouldUsePipelining = true
        urlRequest.httpMethod = request.method.rawValue
        
        if let data = data {
            urlRequest.httpBody = data
            urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        
        return urlRequest
    }
    
    public static func request<T: Codable>(request: Request, data: Data? = nil) throws -> T {
        let data: Data = try self.request(request: request, data: data)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }
    
    public static func request(request: Request, data: Data? = nil) throws -> Data {
        let urlRequest: URLRequest = try API.create(request: request, data: data)
        let (data, response, error) = API.process(request: urlRequest)
        
        if let response = response {
            if 200 <= response.statusCode && response.statusCode < 300, let data: Data = data {
                return data
            } else {
                throw APIError.error(httpCode: response.statusCode, payload: data)
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
