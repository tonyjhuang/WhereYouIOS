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
  
  private struct Constants {
    static let FriendsKey = "ParseHelper.friends"
    static let FriendsDefaultValue = ["gary", "gasper", "allison", "kevin"]
    static let NameKey = "ParseHelper.name"
    static let NameDefaultValue = "tony"
  }
  
  private let defaults = NSUserDefaults.standardUserDefaults()
  
  var friends: [String] {
    get {
      return defaults.objectForKey(Constants.FriendsKey) as? [String] ?? Constants.FriendsDefaultValue
    }
    set {
      defaults.setObject(newValue, forKey: Constants.FriendsKey)
    }
  }
  
  var name: String {
    get {
      return defaults.objectForKey(Constants.NameKey) as? String ?? Constants.NameDefaultValue
    }
    set {
      defaults.setObject(newValue, forKey: Constants.NameKey)
    }
  }
  
  func removeFriend(friend: String) {
    if let index = find(friends, friend) {
      friends.removeAtIndex(index)
    }
  }
}
