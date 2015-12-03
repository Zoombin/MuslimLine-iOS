//
//  LocalNoticationUtils.swift
//  Muslim
//
//  Created by 颜超 on 15/12/1.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit


class LocalNoticationUtils: NSObject {
    
    static func showLocalNotification() {
        if (Config.getLat() == 0 && Config.getLng() == 0) {
            Log.printLog("没定位，无法提醒!")
            return;
        }
        for (var i = 0; i < Config.PrayerNameArray.count; i++) {
            if (PrayTimeUtil.getPrayMediaStatu(i) == 0) {
                continue
            }
            let localNotification = UILocalNotification()
            localNotification.fireDate = NSDate(timeIntervalSinceNow: 5)
            localNotification.alertBody = self.getPrayNoticContent(i)
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        }
    }
    
    static func getPrayNoticContent(index : Int) -> String{
        let names : [String] = Config.PrayNameArray as! [String]
        let prayTime = Config.getPrayTime(index)
        let alertBody = String(format: "%@ %@ %@", NSLocalizedString("noti_prayer_time", comment: ""), names[index], prayTime)
        return alertBody
    }
}
