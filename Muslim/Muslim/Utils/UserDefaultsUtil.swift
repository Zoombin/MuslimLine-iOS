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
        if(userDefault.objectForKey(key as String) != nil) {
            let value : String = userDefault.objectForKey(key as String) as! String
            return value
        }else{
            return "";
        }
    }
    
    /**保存Number数据*/
    static func saveNumber(key :NSString,value :NSNumber){
        userDefault.setObject(value, forKey: key as String)
        userDefault.synchronize()
    }
    
    /**获取保存的Number数据*/
    static func getNumber(key :NSString) -> NSNumber{
        if(userDefault.objectForKey(key as String) != nil) {
            let value : NSNumber = userDefault.objectForKey(key as String) as! NSNumber
            return value
        } else{
            return 0;
        }
    }
    
    /**保存Int数据*/
    static func saveInt(key :NSString,value :Int){
        userDefault.setObject(value, forKey: key as String)
        userDefault.synchronize()
    }
    
    /**获取保存的Int数据*/
    static func getInt(key :NSString) -> Int{
        return getInt(key,defalt: 0)
    }
    static func getInt(key :NSString,defalt:Int) -> Int{
        if(userDefault.objectForKey(key as String) != nil) {
            let value : Int = userDefault.objectForKey(key as String) as! Int
            return value
        }else{
            return defalt;
        }
    }
    
    /**删除数据*/
    static func removeForKey(key : NSString) {
        userDefault.removeObjectForKey(key as String)
        userDefault.synchronize()
    }
    
    
}
