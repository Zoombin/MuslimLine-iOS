//
//  CalendarUtils.swift
//  Muslim
//
//  Created by 颜超 on 15/11/17.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class CalendarUtils: NSObject {
    static func getFirstDayComponents(date : NSDate) -> NSDateComponents {
        let calendar : NSCalendar = NSCalendar.init(calendarIdentifier: Config.getCalenderType())!
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.calendar = calendar
        let flags = NSCalendarUnit(rawValue: UInt.max)
        let components = calendar.components(flags, fromDate:date)
        let firstDate = NSDate(timeInterval:  Double(-(components.day - 1) * 3600 * 24), sinceDate:date)
        let firstComponents = calendar.components(flags, fromDate:firstDate)
        return firstComponents
    }
    
    static func getComponents(date : NSDate) -> NSDateComponents {
        let calendar : NSCalendar = NSCalendar.init(calendarIdentifier: Config.getCalenderType())!
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.calendar = calendar
        let flags = NSCalendarUnit(rawValue: UInt.max)
        let components = calendar.components(flags, fromDate:date)
        return components
    }
    
    static func getDate() -> String {
        let timeFormat = Config.getTimeFormat()
        let date = NSDate()
        let zone = Config.getTimeZone()
        let timeZone = NSTimeZone.init(name: zone)
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = NSLocale.init(localeIdentifier: "en_US")
        if (timeFormat == 0) {
            //24
            dateFormatter.dateFormat = "HH:mm"
        } else {
            //12
            dateFormatter.dateFormat = "hh:mm a"
        }
        
        Log.printLog(dateFormatter.stringFromDate(date))
        return dateFormatter.stringFromDate(date)
    }
    
    static func getWeek() -> String {
        let date = NSDate()
        let zone = Config.getTimeZone()
        let timeZone = NSTimeZone.init(name: zone)
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.stringFromDate(date)
    }
    
    static func currentComponents() -> NSDateComponents{
        let date = NSDate()
        return self.getComponents(date)
    }
    
}
