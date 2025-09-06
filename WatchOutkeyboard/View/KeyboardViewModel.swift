//
//  KeyboardViewModel.swift
//  WatchOutkeyboard
//
//  Created by 어재선 on 9/6/25.
//

import Foundation


class KeyboardViewModel: ObservableObject {
    let chatService = ChatService()
    
    @Published var chatinfo: [ChatResponse]
    @Published var status: String
    
    init(chatinfo: [ChatResponse] = [], status: String = "정상") {
        self.chatinfo = chatinfo
        self.status = status
    
    }
    private var debounceWorkItem: DispatchWorkItem?
    private let debounceInterval: TimeInterval = 1.0
    
    
    func resetTimer(for text: String){
        debounceWorkItem?.cancel()
        
        guard !text.isEmpty else { return }
        
        let newWorkItem = DispatchWorkItem { [weak self] in
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
    
    
    private func sendDataToServer(text: String) async {
        do {
            let result = try await chatService.analyzeText(text: text)
            print(result)
            status = result.riskLevel
        } catch {
            print("error: \(error)")
        }
        
    }
    
    
    
    
}
