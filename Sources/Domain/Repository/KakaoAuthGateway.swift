//
//  KakaoAuthGateway.swift
//  WatchOut
//
//  Created by 어재선 on 6/12/26.
//

import Foundation

/// 카카오 로그인 게이트웨이. SDK 호출을 Presentation에서 격리한다.
public protocol KakaoAuthGateway {
    /// 카카오 로그인(카카오톡 앱 또는 계정)을 수행하고 액세스 토큰을 반환한다.
    @MainActor
    func authorize() async throws -> String
}
