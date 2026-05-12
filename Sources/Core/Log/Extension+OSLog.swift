//
//  OSLog.swift
//  WatchOut
//
//  Created by 어재선 on 9/16/25.
//

import Foundation
import OSLog

public extension OSLog {
    public static let subsystem = Bundle.main.bundleIdentifier!
    public static let network = OSLog(subsystem: subsystem, category: "Network")
    public static let debug = OSLog(subsystem: subsystem, category: "Debug")
    public static let info = OSLog(subsystem: subsystem, category: "Info")
    public static let error = OSLog(subsystem: subsystem, category: "Error")
}

