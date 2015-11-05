//
//  CountryInfo.swift
//  Muslim
//
//  Created by 颜超 on 15/11/5.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class CountryInfo: NSObject {
    var countryCode : NSString?
    var countryName : NSString?
    var dstOffset : NSNumber?
    var gmtOffset : NSNumber?
    var lat : NSNumber?
    var lng : NSNumber?
    var rawOffset : NSNumber?
    var sunrise : NSString?
    var sunset : NSString?
    var time : NSString?
    var timezoneId : NSString?
    
    func initValues(dictionary : NSDictionary) {
        if ((dictionary["countryCode"]) != nil) {
            countryCode = dictionary["countryCode"] as? NSString
        }
        if ((dictionary["countryName"]) != nil) {
            countryName = dictionary["countryName"] as? NSString
        }
        if ((dictionary["dstOffset"]) != nil) {
            dstOffset = dictionary["dstOffset"] as? NSNumber
        }
        if ((dictionary["gmtOffset"]) != nil) {
            gmtOffset = dictionary["gmtOffset"] as? NSNumber
        }
        if ((dictionary["lat"]) != nil) {
            lat = dictionary["lat"] as? NSNumber
        }
        if ((dictionary["lng"]) != nil) {
            lng = dictionary["lng"] as? NSNumber
        }
        if ((dictionary["rawOffset"]) != nil) {
            rawOffset = dictionary["rawOffset"] as? NSNumber
        }
        if ((dictionary["sunrise"]) != nil) {
            sunrise = dictionary["sunrise"] as? NSString
        }
        if ((dictionary["sunset"]) != nil) {
            sunset = dictionary["sunset"] as? NSString
        }
        if ((dictionary["time"]) != nil) {
            time = dictionary["time"] as? NSString
        }
        if ((dictionary["timezoneId"]) != nil) {
            timezoneId = dictionary["timezoneId"] as? NSString
        }
    }
}

//countryCode = CN;
//countryName = China;
//dstOffset = 8;
//gmtOffset = 8;
//lat = "31.296047";
//lng = "120.671041";
//rawOffset = 8;
//sunrise = "2015-11-06 06:15";
//sunset = "2015-11-06 17:05";
//time = "2015-11-05 10:00";
//timezoneId = "Asia/Shanghai";