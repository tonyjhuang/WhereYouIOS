//
//  ParseHelper.swift
//  WhereYou
//
//  Created by Tony on 5/10/15.
//  Copyright (c) 2015 Tony. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

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
    if let index = friends.indexOf(friend) {
      friends.removeAtIndex(index)
    }
  }
  
  func askForLocation(friend: String) {
    let (lat, lng) = getFakeLocation()
    
    let notification: UILocalNotification = UILocalNotification()
    notification.alertBody = friend // text that will be displayed in the notification
    notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
    notification.fireDate = NSDate(timeIntervalSinceNow: 3) // todo item due date (when notification will be fired)
    notification.soundName = UILocalNotificationDefaultSoundName // play default sound
    notification.userInfo = ["friend": friend, "lat":  lat, "lng": lng] // assign a unique identifier to the notification so that we can retrieve it later
    UIApplication.sharedApplication().scheduleLocalNotification(notification)
  }
  
  private func getFakeLocation() -> (lat: CLLocationDegrees, lng: CLLocationDegrees) {
    let latOffset = Double((-1000...1000).randomInt) / 10000
    let lngOffset = Double((-1000...1000).randomInt) / 10000
    return (42.333305 + latOffset, -71.100022 + lngOffset)
  }
}
