import Foundation

// --- 기존 코드 ---
// 보낼 메시지 형식 정의
struct RequestMessage: Encodable {
    let type: String
    let message: String? // "check_fraud" 타입일 때만 사용
}

// 받을 메시지 형식 정의 (type에 따라 디코딩)
// ‼️ 참고: 이 구조체는 {"type": "pong"}, {"type": "error", "message": "..."} 같은 응답에 사용됩니다.
struct ResponseMessage: Decodable {
    let type: String
    let message: String?
}


// --- ⭐️ 추가된 부분 시작 ⭐️ ---
// 'check_fraud'에 대한 서버 응답 전용 구조체
// {"result": { ... }} 형식의 JSON을 처리합니다.
struct FraudCheckResponse: Decodable {
    let result: FraudResult
}
// --- ⭐️ 추가된 부분 끝 ⭐️ ---


// 사기 메시지 체크 결과 (이 구조체는 수정할 필요가 없습니다)
struct FraudResult: Decodable, Identifiable, Equatable {
    let id = UUID() // 뷰에서 식별하기 위함
    let riskLevel: String
    let confidence: Double
    let detectedPatterns: [String]
    let explanation: String
    let recommendedAction: String

    // JSON의 snake_case 키를 Swift의 camelCase 프로퍼티에 매핑
    enum CodingKeys: String, CodingKey {
        case riskLevel = "risk_level"
        case confidence
        case detectedPatterns = "detected_patterns"
        case explanation
        case recommendedAction = "recommended_action"
    }
}
