//
//  APIService.swift
//  WatchOut
//
//  Created by 어재선 on 9/6/25.
//

import Foundation

// API 통신 중 발생할 수 있는 에러를 정의
enum APIError: Error {
    case invalidURL
     case requestFailed(Error)
     case invalidResponse
     case decodingError(Error)
}

// 네트워크 통신을 관리하는 싱글톤 클래스
final class APIService {
    
    static let shared = APIService()
    private init() {}
    
    func post<T: Encodable, U: Decodable>(urlString: String, body: T) async throws -> U {
        // ... (URL 생성, Request 설정 등은 이전과 동일)
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        
        // 6. 받은 데이터 디코딩 (개선된 부분)
        do {
            // ✅ JSONDecoder를 생성하고 키 변환 전략 설정
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            // ✅ 설정된 디코더를 사용하여 데이터 변환
            let decodedData = try decoder.decode(U.self, from: data)
            return decodedData
        } catch {
            throw APIError.decodingError(error)
        }
    }
}

