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
  
  struct Constants {
    static let ActionKey = "action"
    struct Action {
      static let BundleIdentifier: String = "com.tonyjhuang.whereyou"
      static let Ask: String = "\(BundleIdentifier).ASK"
      static let Respond: String = "\(BundleIdentifier).RESPOND"
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
  
  // The big public facing friends list.
  lazy var friendsList: FriendsList = self.getFriendsList()
  
  func getFriendsList() -> FriendsList {
    return FriendsList(friends: self.friends, meta: self.friendsMeta)
  }
  
  func updateFriendsList() {
    friendsList = getFriendsList()
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
  
  var friendsMeta: [String: AnyObject] {
    get {
      /* Work around */
      return currentInstallation.dictionaryForKey("friendsMeta")
    }
    set {
      currentInstallation.setValue(newValue, forKey: "friendsMeta")
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
  
  func markAsAsking(asking: Bool, forFriend friend: String) {
    if friendsMeta[friend] == nil || !(friendsMeta[friend] is [String: AnyObject]) {
      friendsMeta[friend] = ["askPending": asking]
    } else {

      var meta = (friendsMeta[friend] as! [String:AnyObject])
      meta["askPending"] = asking
      friendsMeta[friend] = meta
      print("friendsMeta: \(friendsMeta), meta: \(meta)")
    }
    updateFriendsList()
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
      let notification: UILocalNotification = UILocalNotification()
      notification.alertBody = "\(friend) wants to know where you at!" // text that will be displayed in the notification
      notification.alertAction = "respond" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
      notification.fireDate = NSDate(timeIntervalSinceNow: 3) // todo item due date (when notification will be fired)
      notification.soundName = UILocalNotificationDefaultSoundName // play default sound
      notification.userInfo = [ // for now just mock it out
        Constants.ActionKey: Constants.Action.Ask,
        "name": name
      ]
      UIApplication.sharedApplication().scheduleLocalNotification(notification)

    } else {
      // otherwise, send request to parse but you know... there's nothing there yet.
    }
  
  }
  
  /*********** WORK AROUND ***********/
  func respond() {
    let (lat, lng) = getFakeLocation()
    
    let notification: UILocalNotification = UILocalNotification()
    notification.alertBody = "tony has send you their location!" // text that will be displayed in the notification
    notification.alertAction = "view" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
    notification.fireDate = NSDate(timeIntervalSinceNow: 3) // todo item due date (when notification will be fired)
    notification.soundName = UILocalNotificationDefaultSoundName // play default sound
    notification.userInfo = [
      Constants.ActionKey: Constants.Action.Respond,
      "name": "tony",
      "lat":  lat,
      "lng": lng
    ]
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
  
  func setValue(value: AnyObject?, forKey key: String) {
    if value != nil {
      if let dict = value! as? [String: AnyObject] {
        defaults.setValue(convertToNSDictionary(dict), forKey: key)
      } else {
        defaults.setValue(value, forKey: key)
      }
    } else {
      defaults.setValue(value, forKey: key)
    }
  }
  
  func dictionaryForKey(key: String) -> [String: AnyObject] {
    if let dict = defaults.dictionaryForKey(key) {
      return convertToDictionary(dict)
    } else {
      return [String: AnyObject]()
    }
  }
  
  private func convertToNSDictionary(dict: [String: AnyObject]) -> [NSObject: AnyObject] {
    print("\(dict)")
    var newDict = [NSObject: AnyObject]()
    for (_, key) in dict.keys.enumerate() {
      newDict[key as NSString] = dict[key]
    }
    print("\(newDict)")
    return newDict
  }
  
  private func convertToDictionary(dict: [NSObject: AnyObject]) -> [String: AnyObject] {
    var newDict = [String: AnyObject]()
    for (_, key) in dict.keys.enumerate() {
      newDict[key as! String] = dict[key]
    }
    print("\(newDict)")
    return newDict
  }
  
  func saveInBackgroundWithBlock(block: PFBooleanResultBlock?) { }
  
  func saveEventually() { }
}

class FriendsList : CustomStringConvertible {
  
  var description: String {
    var desc = "["
    for friend in friends {
      desc += "\(friend)"
    }
    return desc + "]"
  }
  
  var friends = [Friend]()
  
  init(friends: [String], meta: [String: AnyObject]) {
    for friendName in friends {
      let friend = Friend(name: friendName, meta: meta[friendName] as? [String:AnyObject] ?? [String:AnyObject]())
      self.friends.append(friend)
    }
    self.friends.sortInPlace {$0.priority > $1.priority }
  }
}

class Friend : CustomStringConvertible {
  let name: String
  var asking: Bool
  var score: Int
  
  var priority: Int {
    get {
      return (asking ? 1000 : 0) + score
    }
  }
  
  var description: String {
    return "[\(name),\(asking),\(score)]"
  }
  
  init(name: String, meta: [String: AnyObject]) {
    self.name = name
    self.asking = meta["askPending"] as? Bool ?? false
    self.score = meta["score"] as? Int ?? 0
  }
}




