//
//  CalendarButton.swift
//  Muslim
//
//  Created by 颜超 on 15/11/17.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class CalendarButton: UIButton {
    var isToday : Bool = false
    var isHoliday : Bool = false
    var isSelect : Bool = false
    var dateTime : NSDate?
    
    func setDate(date : NSDate) {
        self.dateTime = date
        //TODO: 设置日历
        let calendar : NSCalendar = NSCalendar.init(calendarIdentifier: NSPersianCalendar)!
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.calendar = calendar
        let flags = NSCalendarUnit(rawValue: UInt.max)
        let components = calendar.components(flags, fromDate:date)
        
        self.setTitle(String(components.day), forState: UIControlState.Normal)
        checkIsToday(date)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    func checkIsToday(date : NSDate) {
        let currentDate : NSDate = NSDate()
        let calendar : NSCalendar = NSCalendar.init(calendarIdentifier: NSPersianCalendar)!
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.calendar = calendar
        let flags = NSCalendarUnit(rawValue: UInt.max)
        
        let components = calendar.components(flags, fromDate:date)
        let currentComponents = calendar.components(flags, fromDate:currentDate)
        print("%d%d%d  %d%d%d", components.year, components.month, components.day, currentComponents.year, currentComponents.month, currentComponents.day)
        if (components.day == currentComponents.day && components.month == currentComponents.month && components.year == currentComponents.year) {
            isToday = true
            self.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        }
    }
}
