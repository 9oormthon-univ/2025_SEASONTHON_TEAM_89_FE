//
//  APIError.swift
//  WatchOut
//
//  Created by 어재선 on 10/27/25.
//

import Foundation

// MARK: - Validation Error Models
public struct ValidationErrorResponse: Decodable {
    public let detail: [ValidationErrorDetail]
}

public struct ValidationErrorDetail: Decodable {
    public let loc: [LocationType]
    public let msg: String
    public let type: String
    
    public enum LocationType: Decodable {
        case string(String)
        case int(Int)
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let stringValue = try? container.decode(String.self) {
                self = .string(stringValue)
            } else if let intValue = try? container.decode(Int.self) {
                self = .int(intValue)
            } else {
                throw DecodingError.typeMismatch(
                    LocationType.self,
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Expected String or Int"
                    )
                )
            }
        }
        
        public var value: String {
            switch self {
            case .string(let str):
                return str
            case .int(let int):
                return "\(int)"
            }
        }
    }
}

// MARK: - API Error Enum
public enum APIError: Error {
    case unauthorized           // 401
    case forbidden              // 403
    case notFound               // 404
    case conflict               // 409
    case serverError            // 500
    case networkError
    case decodingError
    case validationError(errors: [ValidationErrorDetail])
    case unknown(statusCode: Int, message: String?)
    
    
    

    public var message: String {
        switch self {
        case .unauthorized:
            return "로그인이 필요합니다."
        case .forbidden:
            return "접근 권한이 없습니다."
        case .notFound:
            return "요청한 정보를 찾을 수 없습니다."
        case .conflict:
            return "이미 그룹에 속해 있습니다."
        case .serverError:
            return "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요."
        case .networkError:
            return "네트워크 연결을 확인해주세요."
        case .decodingError:
            return "데이터 처리 중 오류가 발생했습니다."
        case .validationError(let errors):
            
            return errors.first?.msg ?? "입력값을 확인해주세요."
        case .unknown(let statusCode, let message):
            if let message = message {
                return message
            }
            return "알 수 없는 오류가 발생했습니다. (코드: \(statusCode))"
        }
    }
    
    
    public var validationMessages: [String] {
        switch self {
        case .validationError(let errors):
            return errors.map { error in
                let location = error.loc.map { $0.value }.joined(separator: " > ")
                return "\(location): \(error.msg)"
            }
        default:
            return []
        }
    }
    
    
    public var shouldRetry: Bool {
        switch self {
        case .networkError, .serverError:
            return true
        default:
            return false
        }
    }
    
    
    public var requiresLogin: Bool {
        switch self {
        case .unauthorized:
            return true
        default:
            return false
        }
    }
}
