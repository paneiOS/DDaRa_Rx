//
//  Int+.swift
//  DDaRa
//
//  Created by 이정환 on 2023/01/25.
//

import Foundation

extension Int {
  var hour: Int {
    self / 3600
  }
  var minute: Int {
    (self % 3600) / 60
  }
  var seconds: Int {
    (self % 60)
  }
}
