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
    
    func setDate(date : NSDate, month : NSInteger) {
        self.dateTime = date
        //TODO: 设置日历
        let calendar : NSCalendar = NSCalendar.init(calendarIdentifier: Config.getCalenderType())!
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.calendar = calendar
        let flags = NSCalendarUnit(rawValue: UInt.max)
        let components = calendar.components(flags, fromDate:date)
        print("月%d 日%d 周%d", components.month, components.day, components.weekday)
        if (month == components.month) {
            self.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        } else {
            self.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        }
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
        let calendar : NSCalendar = NSCalendar.init(calendarIdentifier: Config.getCalenderType())!
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.calendar = calendar
        let flags = NSCalendarUnit(rawValue: UInt.max)
        
        let components = calendar.components(flags, fromDate:date)
        let currentComponents = calendar.components(flags, fromDate:currentDate)
        if (components.day == currentComponents.day && components.month == currentComponents.month && components.year == currentComponents.year) {
            isToday = true
            self.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        }
    }
}
