//
//  AppDelegate.swift
//  Muslim
//
//  Created by 颜超 on 15/10/21.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
         //Override point for customization after application launch.
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "audioSessionRouteChange:", name: AVAudioSessionRouteChangeNotification, object: nil)
        
        Config.initData()  //获取设置的数据
        configAudio() //设置后台播放
        MobClick.startWithAppkey("56720f23e0f55a884b00838f", reportPolicy: BATCH, channelId: "")//友盟统计
        
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
    
    //设置音频, 开启锁屏操作
    func configAudio(){
        let audio = AVAudioSession.sharedInstance()
        do{
            try audio.setActive(true)
            try audio.setCategory(AVAudioSessionCategoryPlayback)
        }catch let error as NSError{
            print(error.localizedDescription)
        }
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
    }
    
    //MARK: 当收到远程控制:
    override func remoteControlReceivedWithEvent(event: UIEvent?) {
        /*
        enum UIEventSubtype : Int {
        // available in iPhone OS 3.0
        case None
        // for UIEventTypeMotion, available in iPhone OS 3.0
        case MotionShake
        // for UIEventTypeRemoteControl, available in iOS 4.0
        case RemoteControlPlay
        case RemoteControlPause
        case RemoteControlStop
        case RemoteControlTogglePlayPause
        case RemoteControlNextTrack
        case RemoteControlPreviousTrack
        case RemoteControlBeginSeekingBackward
        case RemoteControlEndSeekingBackward
        case RemoteControlBeginSeekingForward
        case RemoteControlEndSeekingForward
        }
        */
        if event != nil{
            Log.printLog("event !!")
            switch event!.type{
            case .RemoteControl:
                switch event!.subtype{
                case .RemoteControlPlay:
                    Log.printLog("play")
                    AudioPlayerMr.getInstance().play()
                case .RemoteControlPause:
                    Log.printLog("pause")
                    AudioPlayerMr.getInstance().pause()
                case .RemoteControlStop:
                    Log.printLog("stop")
                    AudioPlayerMr.getInstance().stop()
                case .RemoteControlTogglePlayPause:
                    Log.printLog("event subtype RemoteControlTogglePlayPause")
                case .RemoteControlNextTrack:
                    Log.printLog("event subtype RemoteControlNextTrack")
                    AudioPlayerMr.getInstance().next(AudioPlayerMr.getInstance().position)
                case .RemoteControlPreviousTrack:
                    //上一个不操作
                    Log.printLog("Previous")
                case .RemoteControlBeginSeekingBackward:
                    //快退不操作
                    Log.printLog("BeginSeekingBackward")
                case .RemoteControlEndSeekingBackward:
                    Log.printLog("RemoteControlEndSeekingBackward")
                case .RemoteControlBeginSeekingForward:
                    //快进不操作
                    Log.printLog("RemoteControlBeginSeekingForward")
                case .RemoteControlEndSeekingForward:
                    Log.printLog("RemoteControlEndSeekingForward")
                case .MotionShake:
                    Log.printLog("event subtype MotionShake")
                case .None:
                    Log.printLog("event subtype None")
                }
            case .Touches:
                Log.printLog("Touches event")
            case .Motion:
                Log.printLog("Motion event")
            default:
                Log.printLog("event default")
            }
        }
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
        NSNotificationCenter.defaultCenter().postNotificationName("ViewBecomeActive", object: nil)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        LocalNoticationUtils.showLocalNotification()
    }
    
    //拔出耳机
    func audioSessionRouteChange(notifi : NSNotification){
        let dict = notifi.userInfo
        let routeDesc : AVAudioSessionRouteDescription = dict![AVAudioSessionRouteChangePreviousRouteKey] as! AVAudioSessionRouteDescription
        let prePort = routeDesc.outputs.first
        if (prePort?.portType == AVAudioSessionPortHeadphones) {
            if(AudioPlayerMr.getInstance().isPlaying){
                AudioPlayerMr.getInstance().pause()
            }
        }
    }


}

