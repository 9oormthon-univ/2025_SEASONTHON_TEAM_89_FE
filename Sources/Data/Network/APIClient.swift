//
//  APIClient.swift
//  WatchOut
//
//  Created by 어재선 on 6/12/26.
//

import Foundation
import Domain
import Platform

public struct APIClient {
    public static let `default` = APIClient(baseURL: URL(string: "https://wiheome.ajb.kr/api")!)

    private let baseURL: URL
    private let session: URLSession

    public init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    public func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let data = try await perform(endpoint)
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            Log.error("디코딩 실패 [\(endpoint.path)]: \(error)")
            throw APIError.decodingError
        }
    }

    public func request(_ endpoint: Endpoint) async throws {
        _ = try await perform(endpoint)
    }

    private func perform(_ endpoint: Endpoint) async throws -> Data {
        var request = URLRequest(url: baseURL.appendingPathComponent(endpoint.path))
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = endpoint.body

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            Log.error("네트워크 실패 [\(endpoint.path)]: \(error.localizedDescription)")
            throw APIError.networkError
        }

        guard let http = response as? HTTPURLResponse else {
            throw APIError.networkError
        }
        guard (200...299).contains(http.statusCode) else {
            Log.error("HTTP \(http.statusCode) [\(endpoint.path)]")
            throw APIError(statusCode: http.statusCode, data: data)
        }
        return data
    }
}

extension APIError {
    init(statusCode: Int, data: Data) {
        if statusCode == 422,
           let validation = try? JSONDecoder().decode(ValidationErrorResponse.self, from: data) {
            self = .validationError(errors: validation.detail)
            return
        }
        switch statusCode {
        case 401: self = .unauthorized
        case 403: self = .forbidden
        case 404: self = .notFound
        case 409: self = .conflict
        case 500...599: self = .serverError
        default: self = .unknown(statusCode: statusCode, message: nil)
        }
    }
}
