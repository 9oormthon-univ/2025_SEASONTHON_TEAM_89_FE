//
//  Path.swift
//  WatchOut
//
//  Created by 어재선 on 9/6/25.
//

import Foundation

import Foundation

class PathModel: ObservableObject {
  @Published var paths: [PathType]
  
  init(paths: [PathType] = []) {
    self.paths = paths
  }
}
