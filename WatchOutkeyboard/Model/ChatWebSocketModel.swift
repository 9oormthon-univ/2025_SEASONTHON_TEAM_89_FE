import Foundation


struct RequestMessage: Encodable {
    let type: String
    let message: String?
}

struct ResponseMessage: Decodable {
    let type: String
    let message: String?
}



struct FraudCheckResponse: Decodable {
    let result: FraudResult
}

struct FraudResult: Decodable, Identifiable, Equatable {
    let id = UUID()
    let riskLevel: String
    let confidence: Double
    let detectedPatterns: [String]
    let explanation: String
    let recommendedAction: String

    enum CodingKeys: String, CodingKey {
        case riskLevel = "risk_level"
        case confidence
        case detectedPatterns = "detected_patterns"
        case explanation
        case recommendedAction = "recommended_action"
    }
}
