//
//  ChatWebSocketService.swift
//  WatchOutkeyboard
//
//  Created by 어재선 on 9/14/25.
//

import Foundation
import Combine

class WebSocketService: NSObject, ObservableObject, URLSessionWebSocketDelegate {
   
        static let shared = WebSocketService()

        private var webSocketTask: URLSessionWebSocketTask?
        private var pingTimer: Timer?
        
        
        @Published var isConnected: Bool = false
        @Published var fraudResult: FraudResult?
        @Published var errorMessage: String?
        
        
        private override init() {
            super.init()
        }
        
        // MARK: - Connection Management
        func connect(urlString: String) {
            
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
            stopPing()
            webSocketTask?.cancel(with: .goingAway, reason: nil)
            webSocketTask = nil
        }

        // MARK: - Message Handling
        private func receiveMessage() {
            webSocketTask?.receive { [weak self] result in
                
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        print("메시지 수신 실패: \(error.localizedDescription)")
                
                        if self?.isConnected == true {
                            self?.errorMessage = "서버와의 연결이 끊어졌습니다: \(error.localizedDescription)"
                        }
                        self?.disconnect()
                        
                    case .success(let message):
                        switch message {
                        case .string(let text):
                            print("수신된 텍스트: \(text)")
                            self?.handleReceivedText(text)
                        case .data(let data):
                            print("수신된 데이터: \(data)")
                        @unknown default:
                            break
                        }
                        self?.receiveMessage()
                    }
                }
            }
        }
            
        private func handleReceivedText(_ text: String) {
            
            self.errorMessage = nil
            
            guard let data = text.data(using: .utf8) else {
                self.errorMessage = "수신된 텍스트를 데이터로 변환할 수 없습니다."
                return
            }
            
            let decoder = JSONDecoder()
            
            
            if let fraudResponse = try? decoder.decode(FraudCheckResponse.self, from: data) {
                print("✅ 사기 탐지 결과 수신")
                self.fraudResult = fraudResponse.result
                return
            }

            
            if let generalResponse = try? decoder.decode(ResponseMessage.self, from: data) {
                switch generalResponse.type {
                case "pong":
                    print("Pong 수신 ⏱️")
                case "error":
                    self.errorMessage = "서버 에러: \(generalResponse.message ?? "알 수 없는 오류")"
                default:
                    print("알 수 없는 타입의 메시지 수신: \(generalResponse.type)")
                }
                return
            }
            
            print("JSON 디코딩 오류: 수신된 데이터가 알려진 형식과 일치하지 않습니다.")
            self.errorMessage = "서버 응답을 처리할 수 없습니다. (데이터 형식 불일치)"
        }


    // MARK: - Sending Messages
    
    func checkFraudMessage(_ message: String) {
        let request = RequestMessage(type: "check_fraud", message: message)
        send(request)
    }

    @objc private func sendPing() {
        print("Ping 전송 핑퐁")
        let request = RequestMessage(type: "ping", message: nil)
        send(request)
    }
    
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
        stopPing()
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
        startPing()
        print("✅ 웹 소켓 연결 성공")
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        DispatchQueue.main.async { self.isConnected = false }
        stopPing()
        print("❌ 웹 소켓 연결 해제")
    }
}
