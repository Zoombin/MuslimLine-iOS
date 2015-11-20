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
    var isThisMonth : Bool = false
    var isCurrentSelected : Bool = false
    var holidayTag : UIImageView?
    
    func setDate(date : NSDate, selectedDate : NSDate, holiday : Bool, month : NSInteger) {
        self.dateTime = date
        //TODO: 设置日历
        let calendar : NSCalendar = NSCalendar.init(calendarIdentifier: Config.getCalenderType())!
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.calendar = calendar
        let flags = NSCalendarUnit(rawValue: UInt.max)
        let components = calendar.components(flags, fromDate:date)
        let selectedComponents = calendar.components(flags, fromDate:selectedDate)
        print("月%d 日%d 周%d", components.month, components.day, components.weekday)
        if (month == components.month) {
            isThisMonth = true
            self.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        } else {
            isThisMonth = false
            self.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        }
        
        if (components.year == selectedComponents.year && components.month == selectedComponents.month && components.day == selectedComponents.day) {
            isCurrentSelected = true
        } else {
            isCurrentSelected = false
        }
        
        self.setTitle(String(components.day), forState: UIControlState.Normal)
        isToday = checkIsToday(date)
        
        
        
        isHoliday = holiday
        holidayTag!.hidden = !holiday
        
        if (isToday) {
            if (isThisMonth && isCurrentSelected) {
                self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                self.setBackgroundImage(UIImage(named: "today_Selected"), forState: UIControlState.Normal)
            } else {
                self.setBackgroundImage(nil, forState: UIControlState.Normal)
            }
        } else {
            if (isCurrentSelected) {
                self.setBackgroundImage(UIImage(named: "no_Selected"), forState: UIControlState.Normal)
            } else {
                self.setBackgroundImage(nil, forState: UIControlState.Normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initTagImage()
    }
    
    func initTagImage() {
        holidayTag = UIImageView(frame: CGRectMake((self.frame.size.width - 5) / 2, self.frame.size.height - 10, 5, 5))
        holidayTag!.image = UIImage(named: "festival_Selected")
        self.addSubview(holidayTag!)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    func checkIsToday(date : NSDate) -> Bool{
        let currentDate : NSDate = NSDate()
        let calendar : NSCalendar = NSCalendar.init(calendarIdentifier: Config.getCalenderType())!
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.calendar = calendar
        let flags = NSCalendarUnit(rawValue: UInt.max)
        
        let components = calendar.components(flags, fromDate:date)
        let currentComponents = calendar.components(flags, fromDate:currentDate)
        if (components.day == currentComponents.day && components.month == currentComponents.month && components.year == currentComponents.year) {
            return true
        }  else {
            return false
        }
    }
}
