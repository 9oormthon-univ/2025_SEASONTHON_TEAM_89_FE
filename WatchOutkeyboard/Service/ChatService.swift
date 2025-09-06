//
//  ChatService.swift
//  WatchOutkeyboard
//
//  Created by 어재선 on 9/6/25.
//

import Foundation


final class ChatService {
    // API의 기본 URL
       private let urlString = "https://wiheome.ajb.kr/api/check_fraud/"
       
       /// 텍스트를 서버로 보내 분석 결과를 받아오는 함수
       /// - Parameter text: 분석할 텍스트
       /// - Returns: 분석 결과(`ChatResult`)
       /// - Throws: `APIError`
       func analyzeText(text: String) async throws -> ChatResult {
           
           // 1. 서버로 보낼 데이터 생성
           let requestBody = ChatRequest(message: text)
           
           // 2. APIService를 사용하여 POST 요청.
           // 보낼 타입은 ChatRequest, 받을 타입은 ChatResponse로 명시.
           let response: ChatResponse = try await APIService.shared.post(
               urlString: urlString,
               body: requestBody
           )
           
           // 3. 받은 응답에서 실제 필요한 result 객체만 반환
           return response.result
           
         
       }
        
    }
    
