//
//  MoyaProvider+Extention.swift
//  WatchOut
//
//  Created by 어재선 on 10/27/25.
//

import Foundation
import Moya

extension MoyaProvider {
    /// 상태 코드 검증이 포함된 요청
    func requestWithValidation(
        _ target: Target,
        completion: @escaping (Result<Response, APIError>) -> Void
    ) {
        self.request(target) { result in
            switch result {
            case .success(let response):
                do {
                    // 200~299 상태 코드만 성공으로 처리
                    let validResponse = try response.filterSuccessfulStatusCodes()
                    completion(.success(validResponse))
                } catch {
                    // 에러 상태 코드는 APIError로 변환
                    if let moyaError = error as? MoyaError {
                        let apiError = APIError(moyaError: moyaError)
                        completion(.failure(apiError))
                    } else {
                        let apiError = APIError.unknown(
                            statusCode: response.statusCode,
                            message: error.localizedDescription
                        )
                        completion(.failure(apiError))
                    }
                }
                
            case .failure(let moyaError):
                // 네트워크 에러 등
                let apiError = APIError(moyaError: moyaError)
                completion(.failure(apiError))
            }
        }
    }
    
    /// 응답 데이터를 디코딩하는 요청 (제네릭)
    func requestWithValidation<T: Decodable>(
        _ target: Target,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        self.requestWithValidation(target) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try response.map(T.self)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.decodingError))
                }
                
            case .failure(let apiError):
                completion(.failure(apiError))
            }
        }
    }
    
    /// Void 응답용 (성공만 확인)
    func requestWithValidation(
        _ target: Target,
        completion: @escaping (Result<Void, APIError>) -> Void
    ) {
        self.requestWithValidation(target) { (result: Result<Response, APIError>) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let apiError):
                completion(.failure(apiError))
            }
        }
    }
}
