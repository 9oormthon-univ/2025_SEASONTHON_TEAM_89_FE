//
//  APIError.swift
//  WatchOut
//
//  Created by 어재선 on 10/27/25.
//

import Foundation
import Moya

// MARK: - Validation Error Models
struct ValidationErrorResponse: Decodable {
    let detail: [ValidationErrorDetail]
}

struct ValidationErrorDetail: Decodable {
    let loc: [LocationType]
    let msg: String
    let type: String
    
    enum LocationType: Decodable {
        case string(String)
        case int(Int)
        
        init(from decoder: Decoder) throws {
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
        
        var value: String {
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
enum APIError: Error {
    case unauthorized           // 401
    case forbidden              // 403
    case notFound               // 404
    case serverError            // 500
    case networkError
    case decodingError
    case validationError(errors: [ValidationErrorDetail])
    case unknown(statusCode: Int, message: String?)
    
    // Moya Error로부터 변환
    init(moyaError: MoyaError) {
        switch moyaError {
        case .statusCode(let response):
            // 422 Validation Error 처리
            if response.statusCode == 422,
               let validationError = try? response.map(ValidationErrorResponse.self) {
                self = .validationError(errors: validationError.detail)
                return
            }
            
            // HTTP 상태 코드별 처리
            switch response.statusCode {
            case 401:
                self = .unauthorized
            case 403:
                self = .forbidden
            case 404:
                self = .notFound
            case 500...599:
                self = .serverError
            default:
                self = .unknown(statusCode: response.statusCode, message: nil)
            }
            
        case .underlying(_, _):
            self = .networkError
            
        case .objectMapping, .encodableMapping, .parameterEncoding:
            self = .decodingError
            
        default:
            self = .unknown(statusCode: -1, message: moyaError.localizedDescription)
        }
    }
    
    // 사용자에게 보여줄 메시지
    var message: String {
        switch self {
        case .unauthorized:
            return "로그인이 필요합니다."
        case .forbidden:
            return "접근 권한이 없습니다."
        case .notFound:
            return "요청한 정보를 찾을 수 없습니다."
        case .serverError:
            return "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요."
        case .networkError:
            return "네트워크 연결을 확인해주세요."
        case .decodingError:
            return "데이터 처리 중 오류가 발생했습니다."
        case .validationError(let errors):
            // 첫 번째 에러 메시지 반환
            return errors.first?.msg ?? "입력값을 확인해주세요."
        case .unknown(let statusCode, let message):
            if let message = message {
                return message
            }
            return "알 수 없는 오류가 발생했습니다. (코드: \(statusCode))"
        }
    }
    
    // Validation 에러의 상세 메시지들
    var validationMessages: [String] {
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
    
    // 재시도 가능 여부
    var shouldRetry: Bool {
        switch self {
        case .networkError, .serverError:
            return true
        default:
            return false
        }
    }
    
    // 로그인 필요 여부
    var requiresLogin: Bool {
        switch self {
        case .unauthorized:
            return true
        default:
            return false
        }
    }
}
