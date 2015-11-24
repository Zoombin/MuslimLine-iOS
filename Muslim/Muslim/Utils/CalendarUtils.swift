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
    
    static func getDate() {
        let date = NSDate()
//        let localDate = date.dateByAddingTimeInterval(interval)
//        print(localDate)
//        NSDate *date = [NSDate date];
//        
//        NSTimeZone *zone = [NSTimeZone systemTimeZone];
//        
//        NSInteger interval = [zone secondsFromGMTForDate: date];
//        
//        NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
//        
//        NSLog(@"%@", localeDate);
    }
    
}
