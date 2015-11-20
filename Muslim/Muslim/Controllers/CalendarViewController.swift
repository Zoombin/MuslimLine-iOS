//
//  CalendarViewController.swift
//  Muslim
//
//  Created by 颜超 on 15/11/16.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var customYearLabel: UILabel!
    @IBOutlet weak var yearMonthLabel: UILabel!
    @IBOutlet weak var holidayTableView: UITableView!
    @IBOutlet weak var calendarBkgView: UIView!
    @IBOutlet weak var calendarView: UIView!
    
    let resultArray : NSMutableArray = NSMutableArray()
    var isIslamic : Bool = true
    let islamic_calendar : String = "islamic"
    let persain_calendar : String = "persain"
    var currentDicionary : NSDictionary?
    var currentDate : NSDate?
    var mslYear : NSInteger?
    var mslMonth : NSInteger?
    
    let cellIdentifier = "myCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isIslamic = Config.getCalenderSelection() == 0
        let calendarType = isIslamic ?
            "islamic_calendar" : "persian_calendar"
        title = NSLocalizedString(calendarType, comment: "")
        //注册ListView的adapter
        holidayTableView!.registerNib(UINib(nibName: "CalendarCell", bundle:nil), forCellReuseIdentifier: cellIdentifier)
        holidayTableView.tableHeaderView = calendarBkgView
        loadHolidays()
        currentDate = NSDate()
        initCalendarView()
    }
    
    @IBAction func backButtonClicked(sender : UIButton) {
        mslMonth = mslMonth! - 1
        if (mslMonth < 1) {
            mslMonth = 12
            mslYear = mslYear! - 1
        }
        let calendar : NSCalendar = NSCalendar.init(calendarIdentifier: Config.getCalenderType())!
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.calendar = calendar
        let flags = NSCalendarUnit(rawValue: UInt.max)
        let components = calendar.components(flags, fromDate:currentDate!)
        components.month = mslMonth!
        components.year = mslYear!
        components.day = 1
        currentDate = components.date
        refreshCalendarButton()
    }
    
    @IBAction func nextButtonClicked(sender : UIButton) {
        mslMonth = mslMonth! + 1
        if (mslMonth > 12) {
            mslMonth = 1
            mslYear = mslYear! + 1
        }
        let calendar : NSCalendar = NSCalendar.init(calendarIdentifier: Config.getCalenderType())!
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.calendar = calendar
        let flags = NSCalendarUnit(rawValue: UInt.max)
        let components = calendar.components(flags, fromDate:currentDate!)
        components.month = mslMonth!
        components.year = mslYear!
        components.day = 1
        currentDate = components.date
        refreshCalendarButton()
    }
    
    func initCalendarView() {
        let rowCount : NSInteger = 7
        let sectionCount : NSInteger = 7
        let calendarViewHeight : CGFloat = calendarView.frame.size.height
        let buttonHeight : CGFloat = calendarViewHeight / sectionCount
        let buttonWidth : CGFloat = buttonHeight
        
        let offSetX = (PhoneUtils.screenWidth - (CGFloat(rowCount) * CGFloat(buttonWidth))) / 2
        
        let weeks : [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        for index in 0...6 {
            let weekLabel : UILabel = UILabel()
            weekLabel.frame = CGRectMake(offSetX + CGFloat(index) * buttonWidth, CGRectGetMinY(calendarView.frame) - buttonHeight, buttonWidth, buttonHeight)
            weekLabel.text = weeks[index]
            weekLabel.textAlignment = NSTextAlignment.Center
            weekLabel.textColor = UIColor.whiteColor()
            calendarBkgView.addSubview(weekLabel)
        }
        
        let todayBtn : UIButton = UIButton.init(type: UIButtonType.Custom)
        todayBtn.frame = CGRectMake((PhoneUtils.screenWidth - 80) / 2, CGRectGetMaxY(calendarView.frame) - buttonHeight, 80, buttonHeight * 3/4)
        todayBtn.layer.cornerRadius = 6.0
        todayBtn.setTitle(NSLocalizedString("prayer_calendar_today", comment: ""), forState: UIControlState.Normal)
        todayBtn.backgroundColor = Colors.greenColor
        todayBtn.addTarget(self, action: Selector.init("todayButtonClicked"), forControlEvents: UIControlEvents.TouchUpInside)
        calendarBkgView.addSubview(todayBtn)
        
        calendarView.backgroundColor = Colors.calendarGray
        refreshCalendarButton()
    }
    
    func todayButtonClicked() {
        currentDate = NSDate()
        refreshCalendarButton()
    }
    
    func refreshCalendarButton() {
        let rowCount : NSInteger = 7
        let sectionCount : NSInteger = 7
        let calendarViewHeight : CGFloat = calendarView.frame.size.height
        let buttonHeight : CGFloat = calendarViewHeight / sectionCount
        let buttonWidth : CGFloat = buttonHeight
        
        let offSetX = (PhoneUtils.screenWidth - (CGFloat(rowCount) * CGFloat(buttonWidth))) / 2
        var currentIndex : CGFloat = 0
        var currentRow : CGFloat = 0

        //当前的第一天
        let firstComponents = CalendarUtils.getFirstDayComponents(currentDate!)
        //当前的
        let components = CalendarUtils.getComponents(currentDate!)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        customYearLabel.text = dateFormatter.stringFromDate(currentDate!)
        mslMonth = firstComponents.month
        mslYear = firstComponents.year
        yearMonthLabel.text = String(format:"%@%d/%d", firstComponents.month > 9 ? "" : "0", mslMonth!, mslYear!)
        
        var day = firstComponents.day + firstComponents.weekday + 5
        print(day)
        if (day > 7) {
            day = day - 7
        }
        
        var firstDate = NSDate(timeInterval: Double(3600 * 24 * -day), sinceDate: firstComponents.date!)

        let hasInit : Bool = calendarView.subviews.count > 0
        for index in 0...41 {
            if (hasInit) {
                firstDate = NSDate(timeInterval: Double(3600 * 24), sinceDate: firstDate)
                let comp = CalendarUtils.getComponents(firstDate)
                let dateStr = String(format: "%d/%d/", comp.month, comp.day)
                let calendarButton : CalendarButton = calendarView.subviews[index] as! CalendarButton
                let bool = checkIsHoliday(dateStr)
                calendarButton.setDate(firstDate, selectedDate: currentDate!, holiday: bool, month: components.month)
            } else {
                firstDate = NSDate(timeInterval: Double(3600 * 24), sinceDate: firstDate)
                let comp = CalendarUtils.getComponents(firstDate)
                let dateStr = String(format: "%d/%d/", comp.month, comp.day)
                let calendarButton : CalendarButton = CalendarButton.init(frame:  CGRectMake(offSetX + currentIndex * buttonWidth, currentRow * buttonHeight, buttonWidth, buttonHeight))
                let bool = checkIsHoliday(dateStr)
                calendarButton.setDate(firstDate, selectedDate: currentDate!, holiday : bool, month: components.month)
                calendarButton.addTarget(self, action: Selector.init("calendarButtonClicked:"), forControlEvents: UIControlEvents.TouchUpInside)
                calendarView.addSubview(calendarButton)
                currentIndex++
                if ((index + 1) % 7 == 0) {
                    currentRow++
                    currentIndex = 0
                }
            }
        }
    }
    
    func checkIsHoliday(dateStr : String) -> Bool{
        if (resultArray.count == 0) {
            return false
        }
        for index in 0...resultArray.count - 1 {
            let dictionary : NSDictionary = resultArray[index] as! NSDictionary
            let holiday = dictionary["time"] as? String
            print(holiday, dateStr)
            if (dateStr == holiday) {
                return true
            }
        }
        return false
    }
    
    func calendarButtonClicked(button : CalendarButton) {
       currentDate = button.dateTime
       refreshCalendarButton()
       holidayTableView.reloadData()
    }
    
    func loadHolidays() {
        let filePath = NSBundle.mainBundle().pathForResource("holidayTimes", ofType: "plist")
        let dictionary : NSDictionary = NSDictionary(contentsOfFile: filePath!)!
        if (isIslamic) {
            let islamic : NSArray = dictionary["islamic"] as! NSArray
            resultArray.addObjectsFromArray(islamic as [AnyObject])
            holidayTableView.reloadData()
        } else {
            let persain : NSArray = dictionary["persain"] as! NSArray
            resultArray.addObjectsFromArray(persain as [AnyObject])
            holidayTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let calendarCell : CalendarCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CalendarCell
        let dictionary : NSDictionary = resultArray[indexPath.row] as! NSDictionary
        calendarCell.holidayNameLabel.text = dictionary["name"] as? String
        calendarCell.dateLabel.text = String(format: "%@%d",  (dictionary["time"] as? String)!, mslYear!)
        return calendarCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
