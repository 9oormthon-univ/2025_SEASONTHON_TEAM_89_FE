import Foundation


public struct RequestMessage: Encodable {
    public let type: String
    public let message: String?
}

public struct ResponseMessage: Decodable {
    public let type: String
    public let message: String?
}



public struct FraudCheckResponse: Decodable {
    public let result: FraudResult
}

public struct FraudResult: Decodable, Identifiable, Equatable {
    public let id = UUID()
    public let riskLevel: String
    public let confidence: Double
    public let detectedPatterns: [String]
    public let explanation: String
    public let recommendedAction: String

    public enum CodingKeys: String, CodingKey {
        case riskLevel = "risk_level"
        case confidence
        case detectedPatterns = "detected_patterns"
        case explanation
        case recommendedAction = "recommended_action"
    }
}
