//
//  AppDelegate.swift
//  WhereYou
//
//  Created by Tony on 5/10/15.
//  Copyright (c) 2015 Tony. All rights reserved.
//

import UIKit
import Parse
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  private struct Constants {
    static let ParseApplicationId = "6P3x2PUkXXXgxh1PCYOd1TeC1qjyrwigadahvJeI"
    static let ParseClientKey = "IK3ABLFW5EGhYqg8bWv9BDpqGkJqEKpzMnUF6NeK"
  }
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)

//    print("didFinishLaunchingWithOptions")
//    if launchOptions != nil {
//      print("userInfo: \(launchOptions![UIApplicationLaunchOptionsLocalNotificationKey])")
//    }
    
    
    GMSServices.provideAPIKey("AIzaSyAzy-GPN0dN1eqJP3QA-EQKr8Bvy9IWAbo")
    
    // Parse shit
    Parse.setApplicationId(Constants.ParseApplicationId, clientKey: Constants.ParseClientKey)
    
    // Register for Push Notitications
    if application.applicationState != UIApplicationState.Background {
      // Track an app open here if we launch with a push, unless
      // "content_available" was used to trigger a background push (introduced in iOS 7).
      // In that case, we skip tracking here to avoid double counting the app-open.
      
      let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
      let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
      var pushPayload = false
      if let options = launchOptions {
        pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
      }
      if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
      }
    }
    
    let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
    if application.respondsToSelector("registerUserNotificationSettings:") {
      application.registerUserNotificationSettings(settings)
      application.registerForRemoteNotifications()
    } else {
      application.registerForRemoteNotificationTypes([.Alert, .Badge, .Sound])
    }
    
    return true
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    //PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(nil, block: nil)
  }
  
  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    let installation = PFInstallation.currentInstallation()
    installation.setDeviceTokenFromData(deviceToken)
    installation.saveEventually(nil)
  }
  
  func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    if error.code == 3010 {
      print("Push notifications are not supported in the iOS Simulator.")
    } else {
      print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
    }
  }
  
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    PFPush.handlePush(userInfo)
    if application.applicationState == UIApplicationState.Inactive {
      PFAnalytics.trackAppOpenedWithRemoteNotificationPayloadInBackground(userInfo, block: nil)
    }
  }
  
  let parse = ParseHelper()
  
  func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
    print("\n\n\nreceived local notification: \n - \(notification.alertBody)\n - \(notification.userInfo)\n\n")
    if let userInfo = notification.userInfo {
      if let action = userInfo[ParseHelper.Constants.ActionKey] as? String {
        let friend = userInfo["name"] as! String
        switch action {
        case ParseHelper.Constants.Action.Ask:
          clearNotifications(friend, application: application)
          print("got an ask! responding..")
          parse.markAsAsking(true, forFriend: friend)
          getMainViewController()?.updateFriendsList()
          //ParseHelper().respond()
          break
        case ParseHelper.Constants.Action.Respond:
          print("got a response!")
          clearNotifications(friend, application: application)
          if let navController = self.window?.rootViewController as? UINavigationController {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let mvc = storyboard.instantiateViewControllerWithIdentifier("MyMapViewController") as? MapViewController {
              if let userInfo = notification.userInfo {
                mvc.friend = userInfo["name"] as! String
                mvc.lat = userInfo["lat"] as! CLLocationDegrees
                mvc.lng = userInfo["lng"] as! CLLocationDegrees
              }
              navController.pushViewController(mvc, animated: true)
            }
          }
          break
        default: break
        }
      }
    }
  }
  
  private func getMainViewController() -> MainViewController? {
    if let rvc = self.window?.rootViewController {
      if let nvc = rvc as? UINavigationController {
        return nvc.viewControllers.first as? MainViewController
      } else {
        if let mvc = rvc as? MainViewController {
          return mvc
        }
      }
    }
    return nil
  }
  
  private func clearNotifications(friend: String, application: UIApplication) {
    application.applicationIconBadgeNumber = 1
    application.applicationIconBadgeNumber = 0
    application.cancelAllLocalNotifications()
  }
  
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
}

