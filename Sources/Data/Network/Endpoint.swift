//
//  Endpoint.swift
//  WatchOut
//
//  Created by 어재선 on 6/12/26.
//

import Foundation

public struct Endpoint {
    public enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }

    public let path: String
    public let method: Method
    public let body: Data?

    public init(path: String, method: Method, body: Data? = nil) {
        self.path = path
        self.method = method
        self.body = body
    }

    public init(path: String, method: Method, json: some Encodable) throws {
        self.init(path: path, method: method, body: try JSONEncoder().encode(json))
    }
}
