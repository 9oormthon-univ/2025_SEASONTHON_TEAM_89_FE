//
//  HangulEngine.swift
//  WatchOutkeyboard
//
//  Created by 어재선 on 9/3/25.
//

import Foundation

/// 한글 엔진의 처리 결과를 담는 구조체
/// - textToInsert: 텍스트 필드에 새로 삽입할 문자열
/// - charactersToDelete: 텍스트 필드에서 지워야 할 글자 수
struct EngineOutput {
    let textToInsert: String
    let charactersToDelete: Int
}

class HangulEngine {
    
    private var status: Hangul?

    func process(jamo: Character) -> EngineOutput {
        
        guard let existingStatus = status else {
            self.status = Hangul(jamo)
            if let char = self.status?.character {
                return EngineOutput(textToInsert: String(char), charactersToDelete: 0)
            }
            return EngineOutput(textToInsert: "", charactersToDelete: 0)
        }

        
        guard let newJamoAsHangul = Hangul(jamo) else {
            
            return finalizeAndStartNew(jamo: jamo)
        }

        
        let (combined, leftover) = Hangul.combineHanguls(existingStatus, newJamoAsHangul)

        
        if let leftover = leftover, let combined = combined {
            self.status = leftover
            if let combinedChar = combined.character, let leftoverChar = leftover.character {
                 return EngineOutput(textToInsert: "\(combinedChar)\(leftoverChar)", charactersToDelete: 1)
            }
        } else if let combined = combined {
            self.status = combined
             if let combinedChar = combined.character {
                 return EngineOutput(textToInsert: String(combinedChar), charactersToDelete: 1)
            }
        } else {
             return finalizeAndStartNew(jamo: jamo)
        }
        
        
        return EngineOutput(textToInsert: "", charactersToDelete: 0)
    }

    
    private func finalizeAndStartNew(jamo: Character) -> EngineOutput {
        let finalizedOutput = finalize()
        self.status = Hangul(jamo)
        
        
        if let newChar = self.status?.character {
            return EngineOutput(textToInsert: finalizedOutput.textToInsert + String(newChar), charactersToDelete: finalizedOutput.charactersToDelete)
        }
        return finalizedOutput
    }
    
    func deleteBackward() -> EngineOutput {
        guard let currentStatus = status, let currentChar = currentStatus.character else {
            return EngineOutput(textToInsert: "", charactersToDelete: 1)
        }

        if let decomposedChar = Hangul.deleteBackward(currentChar) {
            self.status = Hangul(decomposedChar)
            return EngineOutput(textToInsert: String(decomposedChar), charactersToDelete: 1)
        } else {
            self.status = nil
            return EngineOutput(textToInsert: "", charactersToDelete: 1)
        }
    }

    
    func finalize() -> EngineOutput {
        if status != nil {
            self.status = nil
        }
        return EngineOutput(textToInsert: "", charactersToDelete: 0)
    }
    
    func reset() {
        self.status = nil
    }
}

