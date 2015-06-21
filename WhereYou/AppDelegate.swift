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

    print("didFinishLaunchingWithOptions")
    if launchOptions != nil {
      print("userInfo: \(launchOptions![UIApplicationLaunchOptionsLocalNotificationKey])")
    }
    
    
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
      let types: UIRemoteNotificationType = [.Alert, .Badge, .Sound]
      application.registerForRemoteNotificationTypes(types)
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
  
  func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
    print("received local notification: \(notification.alertBody), \(notification.userInfo)")
    //self.window?.rootViewController?.performSegueWithIdentifier("Show Map", sender: nil)
    if let navController = self.window?.rootViewController as? UINavigationController {
      print("yup! \(navController)")
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      if let mvc = storyboard.instantiateViewControllerWithIdentifier("MyMapViewController") as? MapViewController {
        navController.pushViewController(mvc, animated: true)
      }
    }
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

