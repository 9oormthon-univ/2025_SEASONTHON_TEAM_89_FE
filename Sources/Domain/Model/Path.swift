//
//  Path.swift
//  WatchOut
//
//  Created by 어재선 on 9/6/25.
//

import Foundation

import Foundation

public class PathModel: ObservableObject {
  @Published public var paths: [PathType]
  
    public init(paths: [PathType] = []) {
    self.paths = paths
  }
}
