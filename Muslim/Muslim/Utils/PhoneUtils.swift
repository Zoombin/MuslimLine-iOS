//
//  PhoneUtils.swift
//  Muslim
//
//  Created by LSD on 15/10/30.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class PhoneUtils: NSObject {
    static let screenWidth = UIScreen.mainScreen().bounds.size.width//屏幕宽度
    static let screenHeight = UIScreen.mainScreen().bounds.size.height//屏幕高度
    
    //获取系统版本
    static func getAppVer() ->String{
        let infoDictionary = NSBundle.mainBundle().infoDictionary
        let majorVersion : AnyObject? = infoDictionary! ["CFBundleShortVersionString"]
        let appversion = majorVersion as! String
        return appversion
    }
    
    //获取当前系统语言
    static func getSystemLanguage()-> String{
        let userDefault : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let allLanguages : NSArray = userDefault.objectForKey("AppleLanguages") as! NSArray
        return allLanguages[0] as! String
    }
}
