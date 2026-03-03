//
//  MoyaProvider+Extention.swift
//  WatchOut
//
//  Created by 어재선 on 10/27/25.
//

import Foundation
import Moya

extension MoyaProvider {
    
    func requestWithValidation(
        _ target: Target,
        completion: @escaping (Result<Response, APIError>) -> Void
    ) {
        self.request(target) { result in
            switch result {
            case .success(let response):
                do {
                    
                    let validResponse = try response.filterSuccessfulStatusCodes()
                    completion(.success(validResponse))
                } catch {
                    
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
                
                let apiError = APIError(moyaError: moyaError)
                completion(.failure(apiError))
            }
        }
    }
    
    
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
