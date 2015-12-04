//
//  AppDelegate.swift
//  Muslim
//
//  Created by 颜超 on 15/10/21.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Config.initData()  //获取设置的数据
        if ((UIDevice.currentDevice().systemVersion as NSString).doubleValue >= 8.0) {
            if #available(iOS 8.0, *) {
                UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes:[.Badge, .Alert, .Sound], categories: nil))
                UIApplication.sharedApplication().registerForRemoteNotifications()
            } else {
                // Fallback on earlier versions
            }
        } else {
            UIApplication.sharedApplication().registerForRemoteNotificationTypes([.Badge, .Alert, .Sound])
        }
        application.applicationIconBadgeNumber = 0
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        // Override point for customization after application launch.
        self.window!.backgroundColor = UIColor.whiteColor()
        let logoVC = LogoViewController(nibName:"LogoViewController", bundle: nil)
        self.window!.rootViewController = logoVC
        self.window!.makeKeyAndVisible()
        return true
    }
    
    func initMainVC() {
        let vc = MainViewController(nibName:"MainViewController", bundle: nil)
        //创建导航控制器
        let nvc = UINavigationController(rootViewController:vc)
        //设置根视图
        self.window!.rootViewController = nvc
        self.window!.makeKeyAndVisible()
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        application.applicationIconBadgeNumber = 0
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        LocalNoticationUtils.showLocalNotification()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        LocalNoticationUtils.showLocalNotification()
    }


}

