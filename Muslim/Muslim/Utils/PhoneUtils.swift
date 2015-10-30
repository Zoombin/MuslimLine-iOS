//
//  PhoneUtils.swift
//  Muslim
//
//  Created by LSD on 15/10/30.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class PhoneUtils: NSObject {
    
    //获取系统版本
    static func getAppVer() ->String{
        let infoDictionary = NSBundle.mainBundle().infoDictionary
        let majorVersion : AnyObject? = infoDictionary! ["CFBundleShortVersionString"]
        let appversion = majorVersion as! String
        return appversion
    }
}
