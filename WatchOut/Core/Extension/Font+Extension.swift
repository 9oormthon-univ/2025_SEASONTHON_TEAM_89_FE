//
//  Font+Extension.swift
//  WatchOut
//
//  Created by 어재선 on 9/3/25.
//

import SwiftUI

extension Font {
    
    
    // Headline
    static let gHeadline01: Font = .custom("GangwonEduPower", size: 32)
    
    static let pHeadline01: Font = .custom("Pretendard-SemiBold", size: 22)
    static let pvHeadline01: Font = .custom("PretendardVariable", size: 22)
        .weight(.bold)
    
    static let pHeadline02: Font = .custom("Pretendard-Medium", size: 18)
    static let pvHeadline02: Font = .custom("PretendardVariable", size: 18)
        .weight(.medium)
    
    static let pHeadline03: Font = .custom("Pretendard-SemiBold", size: 16)
    static let pvHeadline03: Font = .custom("PretendardVariable", size: 16)
        .weight(.semibold)
        
    // Subtitle
    static let pSubtitle03: Font = .custom("Pretendard-Regular", size: 16)
    static let pvSubtitle03: Font = .custom("PretendardVariable", size: 16)
        .weight(.regular)
    // Body
    static let pBody01: Font = .custom("Pretendard-Regular", size: 18)
    static let pvBody01: Font = .custom("PretendardVariable", size: 18)
        .weight(.regular)
    
    static let pBody02: Font = .custom("Pretendard-Medium", size: 16)
    static let pvBody02: Font = .custom("PretendardVariable", size: 16)
        .weight(.regular)

    // Caption
    static let pCaption01: Font = .custom("Pretendard-Medium", size: 14)
    static let pvCaption01: Font = .custom("PretendardVariable", size: 14)
        .weight(.medium)
    
    static let keyboardFont: Font = .custom("Pretendard-Regular", size: 22)
    static let pvkeyBoardFont: Font = .custom("PretendardVariable", size: 22)
        .weight(.regular)
}
