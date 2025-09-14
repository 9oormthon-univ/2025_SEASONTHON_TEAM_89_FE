//
//  TypingDebounceManager.swift
//  WatchOutkeyboard
//
//  Created by 어재선 on 9/5/25.
//
import Foundation

@MainActor
class TypingDebounceManager: ObservableObject {
    
    // ✅ @Published: 이 프로퍼티들의 값이 바뀔 때마다 자동으로 뷰에 알려줍니다.
    @Published var status: String = "정상"
    @Published var isLoading: Bool = false
    
    // 디바운싱을 위한 DispatchWorkItem
    private var debounceWorkItem: DispatchWorkItem?
    private let chatService = ChatService()
    
    // 대기 시간
    private let debounceInterval: TimeInterval = 2.0

    /// 키가 입력될 때마다 호출될 함수. 타이머를 리셋합니다.
    func resetTimer(for text: String){
        // 이전에 예약된 작업이 있다면 취소
        debounceWorkItem?.cancel()
        
        // 서버로 보낼 텍스트가 비어있으면 상태를 초기화하고 종료
        guard !text.isEmpty else {
            self.status = "정상"
            self.isLoading = false
            return
        }
        
        // "서버에 데이터를 보내는" 새로운 작업을 정의
        let newWorkItem = DispatchWorkItem { [weak self] in
            // Task를 사용하여 비동기 작업을 호출
            Task {
                await self?.sendDataToServer(text: text)
            }
        }
        
        // 새로운 작업을 1초 뒤에 백그라운드 큐에서 실행하도록 예약
        DispatchQueue.global().asyncAfter(deadline: .now() + debounceInterval, execute: newWorkItem)
        
        self.debounceWorkItem = newWorkItem
    }
    
    // 실제 서버 통신을 하는 비동기 함수
    private func sendDataToServer(text: String) async {
        // isLoading 상태를 true로 변경하여 UI에 로딩 중임을 알림
        self.isLoading = true
        
        do {
            let result = try await chatService.analyzeText(text: text)
            print(result)
            // ✅ @Published 프로퍼티인 status 값을 변경 -> UI가 자동으로 업데이트됨
            self.status = result.riskLevel
            print("Status updated to: \(status)")
        } catch {
            print("Error sending data to server: \(error.localizedDescription)")
            self.status = "오류" // 에러 발생 시 상태
        }
        
        // 통신이 끝나면 isLoading 상태를 false로 변경
        self.isLoading = false
    }
}
