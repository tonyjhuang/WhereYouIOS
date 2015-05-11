//
//  ParseHelper.swift
//  WhereYou
//
//  Created by Tony on 5/10/15.
//  Copyright (c) 2015 Tony. All rights reserved.
//

import Foundation

class ParseHelper {
  
  struct Static {
    static var onceToken : dispatch_once_t = 0
    static var instance  : ParseHelper? = nil
  }
  
  class var sharedInstance : ParseHelper {
    dispatch_once(&Static.onceToken) {
      Static.instance = ParseHelper()
    }
    return Static.instance!
  }
  
  
  let friends = ["Friend 1", "Friend 2", "Friend 3", "Friend 4"]
  
  func getFriends() -> [String] {
    return friends
  }

}
