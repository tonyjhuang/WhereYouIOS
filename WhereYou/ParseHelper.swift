//
//  ParseHelper.swift
//  WhereYou
//
//  Created by Tony on 5/10/15.
//  Copyright (c) 2015 Tony. All rights reserved.
//

import Foundation
import UIKit
import Parse
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
    static let ParseKeyAction = "action"
    struct Action {
      static let BundleIdentifier = "com.tonyjhuang.whereyou"
      static let Ask = "\(BundleIdentifier).ASK"
    }
  }
  
  private let currentInstallation: GhettoPFInstallation;
  init() {
    currentInstallation = GhettoPFInstallation.currentInstallation()
  }
  
  
  
  private let defaults = NSUserDefaults.standardUserDefaults()
  
  var friends: [String] {
    get {
      return currentInstallation.objectForKey("friends") as? [String] ?? [String]()
    }
    set {
      currentInstallation.setValue(newValue, forKey: "friends")
      currentInstallation.saveInBackgroundWithBlock(nil)
    }
  }
  
  var name: String {
    get {
      let currentName = currentInstallation.objectForKey("name") as? String
      if currentName == nil {
        return "tony"
      } else {
        return currentName as String!
      }
    }
    set {
      currentInstallation.setValue(newValue, forKey: "name")
      currentInstallation.saveInBackgroundWithBlock(nil)
    }
  }
  
  func addFriend(friend: String, block: ([String] -> Void)?) {
    if friends.contains(friend) {
      print("already added \(friend). returning")
      if block != nil {
        block!(friends)
        return
      }
    }
    
    // If we don't have this friend in our friends list, first check if this person exists in our
    // backend, if they do, then simply add it to our installation object and notify the block.
    PFCloud.callFunctionInBackground("checkName", withParameters: ["name": friend]) { (response, error) -> Void in
      if let nameExists = response as? Bool {
        if nameExists {
          print("adding \(friend) to friends list")
          self.friends += [friend]
          if block != nil {
            block!(self.friends)
          }
        } else {
          print("there's no \(friend) in our db!")
          if block != nil {
            block!(self.friends)
          }
        }
      } else {
        print(error)
        if block != nil {
          block!(self.friends)
        }
      }
    }
  }
  
  func removeFriend(friend: String) {
    if let index = friends.indexOf(friend) {
      friends.removeAtIndex(index)
    }
  }
  
  func askForLocation(friend: String) {
    /*
    
    /***** WORKING CODE ******/
    let query = PFInstallation.query()!
    query.whereKey("name", equalTo: friend)
    
    let data: [String: String] = [
      "name": "test",
      "alert": "hey!",
      Constants.ParseKeyAction: Constants.Action.Ask
    ]
    
    let push = PFPush()
    push.setQuery(query)
    push.setData(data)
    
    push.sendPushInBackgroundWithBlock({ (bool, error) -> Void in
      print("pushed");
    })
    /***** WORKING CODE ******/
*/
    
    if friend == "tony" {
      // 'ask' for location.
    } else {
      // otherwise, send request to parse but you know... there's nothing there yet.
    }
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

class GhettoPFInstallation {
  
  private class var sharedInstance: GhettoPFInstallation {
    struct Static {
      static let instance: GhettoPFInstallation = GhettoPFInstallation()
    }
    return Static.instance
  }
  
  class func currentInstallation() -> GhettoPFInstallation {
    return GhettoPFInstallation.sharedInstance
  }
  
  private let defaults = NSUserDefaults.standardUserDefaults()
  
  func objectForKey(key: String) -> AnyObject? {
    return defaults.objectForKey(key)
  }
  
  func setValue(value: AnyObject, forKey key: String) {
    defaults.setValue(value, forKey: key)
  }
  
  func saveInBackgroundWithBlock(block: PFBooleanResultBlock?) { }
  
  func saveEventually() { }
}
