//
//  Colours.swift
//  WhereYou
//
//  Created by Tony on 5/28/15.
//  Copyright (c) 2015 Tony. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
  
  private struct Colors {
    static let RED_ACCENT: UInt32 = 0xEF5350
    static var PINK_ACCENT : UInt32 { return 0xEC407A }
    static var PURPLE_ACCENT : UInt32 { return 0xAB47BC }
    static var DEEP_PURPLE_ACCENT : UInt32 { return 0x7E57C2 }
    static var INDIGO_ACCENT : UInt32 { return 0x5C6BC0 }
    static var BLUE_ACCENT : UInt32 { return 0x42A5F5 }
    static var LIGHT_BLUE_ACCENT : UInt32 { return 0x29B6F6 }
    static var CYAN_ACCENT : UInt32 { return 0x26C6DA }
    static var TEAL_ACCENT : UInt32 { return 0x26A69A }
    static var GREEN_ACCENT : UInt32 { return 0x66BB6A }
    static var LIGHT_GREEN_ACCENT : UInt32 { return 0x9CCC65 }
    static var LIME_ACCENT : UInt32 { return 0xD4E157 }
    static var YELLOW_ACCENT : UInt32 { return 0xFFEE58 }
    static var AMBER_ACCENT : UInt32 { return 0xFFCA28 }
    static var ORANGE_ACCENT : UInt32 { return 0xFFA726 }
    static var DEEP_ORANGE_ACCENT : UInt32 { return 0xFF7043 }
    static var BROWN_ACCENT : UInt32 { return 0x8D6E63 }
    static var GREY_ACCENT : UInt32 { return 0xBDBDBD }
    static var BLUE_GREY_ACCENT : UInt32 { return 0x78909C }
    
  }
  
  static var RED_ACCENT : UInt32 { return 0xEF5350 }
  static var PINK_ACCENT : UInt32 { return 0xEC407A }
  static var PURPLE_ACCENT : UInt32 { return 0xAB47BC }
  static var DEEP_PURPLE_ACCENT : UInt32 { return 0x7E57C2 }
  static var INDIGO_ACCENT : UInt32 { return 0x5C6BC0 }
  static var BLUE_ACCENT : UInt32 { return 0x42A5F5 }
  static var LIGHT_BLUE_ACCENT : UInt32 { return 0x29B6F6 }
  static var CYAN_ACCENT : UInt32 { return 0x26C6DA }
  static var TEAL_ACCENT : UInt32 { return 0x26A69A }
  static var GREEN_ACCENT : UInt32 { return 0x66BB6A }
  static var LIGHT_GREEN_ACCENT : UInt32 { return 0x9CCC65 }
  static var LIME_ACCENT : UInt32 { return 0xD4E157 }
  static var YELLOW_ACCENT : UInt32 { return 0xFFEE58 }
  static var AMBER_ACCENT : UInt32 { return 0xFFCA28 }
  static var ORANGE_ACCENT : UInt32 { return 0xFFA726 }
  static var DEEP_ORANGE_ACCENT : UInt32 { return 0xFF7043 }
  static var BROWN_ACCENT : UInt32 { return 0x8D6E63 }
  static var GREY_ACCENT : UInt32 { return 0xBDBDBD }
  static var BLUE_GREY_ACCENT : UInt32 { return 0x78909C }
  
  static let colors : [UInt32] = [
    Colors.RED_ACCENT,
    RED_ACCENT,
    PINK_ACCENT,
    PURPLE_ACCENT,
    DEEP_PURPLE_ACCENT,
    INDIGO_ACCENT,
    BLUE_ACCENT,
    LIGHT_BLUE_ACCENT,
    TEAL_ACCENT,
    GREEN_ACCENT,
    LIGHT_GREEN_ACCENT,
    LIME_ACCENT,
    YELLOW_ACCENT,
    AMBER_ACCENT,
    ORANGE_ACCENT,
    DEEP_ORANGE_ACCENT
  ]
  
  class func UIColorFromRGB(rgbValue: UInt32) -> UIColor {
    return UIColor(
      red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }
  
  class func getRandomColor() -> UIColor {
    var index = Int(arc4random_uniform(UInt32(colors.count)))
    return UIColorFromRGB(colors[index]);
  }
  
  class func getRandomColor(string: String) -> UIColor {
    var index = abs(string.hashValue % colors.count)
    return UIColorFromRGB(colors[index])
  }
  
  
  
}