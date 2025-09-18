//
//  ChatWebSocketService.swift
//  WatchOutkeyboard
//
//  Created by 어재선 on 9/14/25.
//

import Foundation
import Combine // Timer를 위해 필요

class WebSocketService: NSObject, ObservableObject, URLSessionWebSocketDelegate {
    // ⭐️ 1. 싱글톤 인스턴스 생성
        // 이제 앱 전체에서 이 'shared' 인스턴스 하나만 사용하게 됩니다.
        static let shared = WebSocketService()

        private var webSocketTask: URLSessionWebSocketTask?
        private var pingTimer: Timer?
        
        // Published 프로퍼티: UI가 데이터 변경을 감지
        @Published var isConnected: Bool = false
        @Published var fraudResult: FraudResult?
        @Published var errorMessage: String?
        
        // ⭐️ 2. 외부에서 인스턴스를 추가로 생성하는 것을 방지
        private override init() {
            super.init()
        }
        
        // MARK: - Connection Management
        func connect(urlString: String) {
            // 이미 연결되어 있다면 중복 실행 방지
            guard !isConnected, webSocketTask == nil else {
                print("이미 연결되어 있거나 연결 시도 중입니다.")
                return
            }
            
            guard let url = URL(string: urlString) else { return }
            let request = URLRequest(url: url)
            print(request)
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
            webSocketTask = session.webSocketTask(with: request)
            webSocketTask?.resume()
            receiveMessage()
        }

        func disconnect() {
            stopPing() // 연결 해제 시 타이머 중지
            webSocketTask?.cancel(with: .goingAway, reason: nil)
            webSocketTask = nil // task를 nil로 만들어 재연결이 가능하도록 함
        }

        // MARK: - Message Handling
        private func receiveMessage() {
            webSocketTask?.receive { [weak self] result in
                // UI 업데이트는 항상 메인 스레드에서 수행
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        print("메시지 수신 실패: \(error.localizedDescription)")
                        // 연결이 실제로 끊어졌을 때만 에러 메시지 표시
                        if self?.isConnected == true {
                            self?.errorMessage = "서버와의 연결이 끊어졌습니다: \(error.localizedDescription)"
                        }
                        self?.disconnect() // 연결 상태 정리
                        
                    case .success(let message):
                        switch message {
                        case .string(let text):
                            print("수신된 텍스트: \(text)") // 디버깅을 위해 수신된 원본 JSON 출력
                            self?.handleReceivedText(text)
                        case .data(let data):
                            print("수신된 데이터: \(data)")
                        @unknown default:
                            break
                        }
                        // ✅ 성공적으로 메시지를 받았을 때만 다음 메시지를 기다립니다.
                        self?.receiveMessage()
                    }
                }
            }
        }
            
        private func handleReceivedText(_ text: String) {
            // 이전 에러 메시지 초기화
            self.errorMessage = nil
            
            guard let data = text.data(using: .utf8) else {
                self.errorMessage = "수신된 텍스트를 데이터로 변환할 수 없습니다."
                return
            }
            
            let decoder = JSONDecoder()
            
            // 시도 1: 'check_fraud' 응답 형식(FraudCheckResponse)으로 디코딩
            if let fraudResponse = try? decoder.decode(FraudCheckResponse.self, from: data) {
                print("✅ 사기 탐지 결과 수신")
                self.fraudResult = fraudResponse.result
                return // 성공했으므로 함수 종료
            }

            // 시도 2: 일반 응답 형식(ResponseMessage)으로 디코딩
            if let generalResponse = try? decoder.decode(ResponseMessage.self, from: data) {
                switch generalResponse.type {
                case "pong":
                    print("Pong 수신 ⏱️")
                case "error":
                    self.errorMessage = "서버 에러: \(generalResponse.message ?? "알 수 없는 오류")"
                default:
                    print("알 수 없는 타입의 메시지 수신: \(generalResponse.type)")
                }
                return // 성공했으므로 함수 종료
            }
            
            // 두 가지 형식 모두 디코딩 실패
            print("JSON 디코딩 오류: 수신된 데이터가 알려진 형식과 일치하지 않습니다.")
            self.errorMessage = "서버 응답을 처리할 수 없습니다. (데이터 형식 불일치)"
        }


    // MARK: - Sending Messages
    
    // 1. 사기 메시지 체크 요청
    func checkFraudMessage(_ message: String) {
        let request = RequestMessage(type: "check_fraud", message: message)
        send(request)
    }

    // 2. Ping 보내기
    @objc private func sendPing() {
        print("Ping 전송 핑퐁")
        let request = RequestMessage(type: "ping", message: nil)
        send(request)
    }
    
    // 실제 메시지 전송 로직 (Codable -> JSON)
    private func send<T: Encodable>(_ messageObject: T) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(messageObject)
            if let jsonString = String(data: data, encoding: .utf8) {
                webSocketTask?.send(.string(jsonString)) { error in
                    if let error = error {
                        print("메셔지 전송 오류: \(error)")
                    }
                }
            }
        } catch {
            print("JSON 인코딩 오류: \(error)")
        }
    }


    // MARK: - Ping Timer
    private func startPing() {
        stopPing() // 만약을 위해 기존 타이머 중지
        pingTimer = Timer.scheduledTimer(timeInterval: 10.0,
                                         target: self,
                                         selector: #selector(sendPing),
                                         userInfo: nil,
                                         repeats: true)
    }

    private func stopPing() {
        pingTimer?.invalidate()
        pingTimer = nil
    }

    // MARK: - URLSessionWebSocketDelegate
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        DispatchQueue.main.async { self.isConnected = true }
        startPing() // 연결 성공 시 Ping 타이머 시작
        print("✅ 웹 소켓 연결 성공")
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        DispatchQueue.main.async { self.isConnected = false }
        stopPing() // 연결 해제 시 Ping 타이머 중지
        print("❌ 웹 소켓 연결 해제")
    }
}
