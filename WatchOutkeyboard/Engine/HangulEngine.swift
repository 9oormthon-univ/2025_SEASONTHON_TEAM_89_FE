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
    
    /// 현재 조합 중인 글자의 상태를 저장하는 변수. nil일 수 있습니다.
    private var status: Hangul?

    /// 새로운 자모를 입력받아 처리합니다.
    func process(jamo: Character) -> EngineOutput {
        // 1. 조합 중인 글자가 없다면, 새로 조합을 시작합니다.
        guard let existingStatus = status else {
            self.status = Hangul(jamo)
            if let char = self.status?.character {
                return EngineOutput(textToInsert: String(char), charactersToDelete: 0)
            }
            return EngineOutput(textToInsert: "", charactersToDelete: 0)
        }

        // 2. 새로 들어온 자모가 유효한지 확인합니다.
        guard let newJamoAsHangul = Hangul(jamo) else {
            // 유효하지 않으면, 기존 글자를 확정하고 새 문자를 뒤에 붙입니다.
            return finalizeAndStartNew(jamo: jamo)
        }

        // 3. 이제 existingStatus와 newJamoAsHangul이 모두 nil이 아님이 확실하므로, 결합을 시도합니다.
        let (combined, leftover) = Hangul.combineHanguls(existingStatus, newJamoAsHangul)

        // 4. 조합 결과에 따라 상태를 업데이트하고 결과를 반환합니다.
        if let leftover = leftover, let combined = combined { // 결과가 두 글자로 나뉠 때
            self.status = leftover
            if let combinedChar = combined.character, let leftoverChar = leftover.character {
                 return EngineOutput(textToInsert: "\(combinedChar)\(leftoverChar)", charactersToDelete: 1)
            }
        } else if let combined = combined { // 결과가 한 글자로 합쳐질 때
            self.status = combined
             if let combinedChar = combined.character {
                 return EngineOutput(textToInsert: String(combinedChar), charactersToDelete: 1)
            }
        } else { // 조합 실패 시
             return finalizeAndStartNew(jamo: jamo)
        }
        
        // 위에서 모든 케이스가 처리되지만, 만약을 위한 기본 반환값
        return EngineOutput(textToInsert: "", charactersToDelete: 0)
    }

    /// 기존 조합을 확정하고 새로운 문자 입력을 시작하는 헬퍼 함수
    private func finalizeAndStartNew(jamo: Character) -> EngineOutput {
        let finalizedOutput = finalize() // 기존 글자 확정
        self.status = Hangul(jamo) // 새 자모로 상태 업데이트
        
        // 확정된 글자와 새로 시작하는 글자를 합쳐서 반환
        if let newChar = self.status?.character {
            return EngineOutput(textToInsert: finalizedOutput.textToInsert + String(newChar), charactersToDelete: finalizedOutput.charactersToDelete)
        }
        return finalizedOutput
    }
    
    /// 백스페이스를 처리합니다.
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

    /// 현재 조합 중인 글자를 확정하고, 조합 상태를 초기화합니다.
    func finalize() -> EngineOutput {
        guard let char = status?.character else {
            return EngineOutput(textToInsert: "", charactersToDelete: 0)
        }
        self.status = nil
        return EngineOutput(textToInsert: String(char), charactersToDelete: 1)
    }
    
    /// 현재 조합을 강제로 초기화합니다.
    func reset() {
        self.status = nil
    }
}

