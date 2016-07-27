//
//  Util.swift
//  Pokemon
//
//  Created by Reza Shirazian on 2016-07-15.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import Foundation

class Util {
  static func idToImageName(id: Int) -> String {
    switch id {
    case 0...9:
      return "00\(id)"
    case 10...99:
      return "0\(id)"
    default:
      return "\(id)"
    }
  }
}
