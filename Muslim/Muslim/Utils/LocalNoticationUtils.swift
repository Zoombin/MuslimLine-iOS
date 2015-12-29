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
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        for (var i = 0; i < Config.PrayNameArray.count; i++) {
            var prayTime = Config.getPrayTime(i)
            let timeFormat = Config.getTimeFormat()
            let timeZone = NSTimeZone.init(name: Config.getTimeZone())
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeZone = timeZone
            dateFormatter.locale = NSLocale.init(localeIdentifier: "en_US")
            if (timeFormat == 0) {
                //24
                dateFormatter.dateFormat = "HH:mm"
            } else {
                //12
                prayTime = prayTime.uppercaseString
                let isAfternoon = prayTime.containsString("PM")
                prayTime = prayTime.stringByReplacingOccurrencesOfString(" AM", withString: "")
                prayTime = prayTime.stringByReplacingOccurrencesOfString(" PM", withString: "")
                var hour = prayTime.componentsSeparatedByString(":").first! as NSString
                if (isAfternoon && hour.integerValue < 12) {
                    hour = String(format: "%d", hour.integerValue + 12)
                }
                let minute = prayTime.componentsSeparatedByString(":").last! as NSString
                prayTime = String(format: "%@:%@", hour, minute)
                dateFormatter.dateFormat = "HH:mm"
            }
            let fireDate = dateFormatter.dateFromString(prayTime)
            let localNotification = UILocalNotification()
            localNotification.fireDate = fireDate
            localNotification.alertBody = self.getPrayNoticContent(i)
            localNotification.timeZone = timeZone
            //TODO: 提醒但是没提示音
            if (PrayTimeUtil.getPrayMediaStatu(i) != 0) {
                localNotification.soundName = PrayTimeUtil.getPrayMedia(i)
            }
            localNotification.repeatInterval = NSCalendarUnit.Day
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
