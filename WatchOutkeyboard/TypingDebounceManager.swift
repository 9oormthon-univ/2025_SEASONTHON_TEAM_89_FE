//
//  TypingDebounceManager.swift
//  WatchOutkeyboard
//
//  Created by 어재선 on 9/5/25.
//

import Foundation

class TypingDebounceManager {
    
    // 디바운싱을 위한 DispatchWorkItem
    private var debounceWorkItem: DispatchWorkItem?
    
    // 대기 시간
    private let debounceInterval: TimeInterval = 1.0
    
    /// 키가 입력될 때마다 호출될 함수. 타이머를 리셋합니다.
    func resetTimer(for text: String) {
        // 이전에 예약된 작업이 있다면 취소
        debounceWorkItem?.cancel()
        
        // 서버로 보낼 텍스트가 비어있으면 아무것도 하지 않음
        guard !text.isEmpty else { return }
        
        // "서버에 데이터를 보내는" 새로운 작업을 정의
        let newWorkItem = DispatchWorkItem { [weak self] in
            // 2초 후에 백그라운드 스레드에서 실행
            DispatchQueue.main.async {
                print("SwiftUI Tap Debounce 성공: \(text)")
                Task {
                    await self?.sendDataToServer(text: text)
                }
            }
        }
        
        // 새로운 작업을 2초 뒤에 백그라운드 큐에서 실행하도록 예약
        DispatchQueue.global().asyncAfter(deadline: .now() + debounceInterval, execute: newWorkItem)
        
        self.debounceWorkItem = newWorkItem
    }
    
    // 실제 서버 통신을 하는 비동기 함수
    private func sendDataToServer(text: String) async {
        print("서버로 데이터 전송 시도: \(text)")
        // 여기에 URLSession 통신 코드를 넣습니다.
    }
}
