//
//  NSUserDefaultsUtil.swift
//  Muslim
//
//  Created by LSD on 15/11/6.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class UserDefaultsUtil: NSObject {
    static let userDefault : NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    /**保存String数据*/
    static func saveString(key :NSString,value :NSString){
        userDefault.setObject(value, forKey: key as String)
        userDefault.synchronize()
    }
    
    /**获取保存的String数据*/
    static func getString(key :NSString) -> String{
        let value : String = userDefault.objectForKey(key as String) as! String
        return value
    }
    
    /**保存Int数据*/
    static func saveInt(key :NSString,value :Int){
        userDefault.setObject(value, forKey: key as String)
        userDefault.synchronize()
    }
    
    /**获取保存的Int数据*/
    static func getInt(key :NSString) -> Int{
        let value : Int = userDefault.objectForKey(key as String) as! Int
        return value
    }
    
}
