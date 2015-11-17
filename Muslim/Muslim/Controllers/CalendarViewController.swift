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
        title = NSLocalizedString("islamic_calendar", comment: "")
        //注册ListView的adapter
        holidayTableView!.registerNib(UINib(nibName: "CalendarCell", bundle:nil), forCellReuseIdentifier: cellIdentifier)
        holidayTableView.tableHeaderView = calendarBkgView
        loadHolidays()
        let components = CalendarUtils.getComponents(NSDate())
        mslYear = components.year
        mslMonth = components.month
//        currentComponents = getComponents(NSDate())
        currentDate = NSDate()
        initCalendarView()
    }
    
    @IBAction func backButtonClicked(sender : UIButton) {
//        currentComponents?.month = (currentComponents?.month)! - 1
//        currentDate = CalendarUtils.getPriousorLaterDateFromDate(currentDate!, month: -1)
        print(currentDate)
        reloadMonthInfo()
    }
    
    @IBAction func nextButtonClicked(sender : UIButton) {
//        currentComponents?.month = (currentComponents?.month)! + 1
//        currentDate = CalendarUtils.getPriousorLaterDateFromDate(currentDate!, month: 1)
        print(currentDate)
        reloadMonthInfo()
    }
    
    func reloadMonthInfo() {
//        yearMonthLabel.text = String(format: "%d/%d", mslMonth / mslYear)
    }
    
    func initCalendarView() {
        let rowCount : NSInteger = 7
        let sectionCount : NSInteger = 7
        let calendarViewHeight : CGFloat = calendarView.frame.size.height
        let buttonHeight : CGFloat = calendarViewHeight / sectionCount
        let buttonWidth : CGFloat = buttonHeight
        
        let offSetX = (PhoneUtils.screenWidth - (CGFloat(rowCount) * CGFloat(buttonWidth))) / 2
        print(offSetX)
        
        var currentIndex : CGFloat = 0
        var currentRow : CGFloat = 0
        var firstDate : NSDate = NSDate()
        let weeks : [String] = ["Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"]
        for index in 0...6 {
            let weekLabel : UILabel = UILabel()
            weekLabel.frame = CGRectMake(offSetX + CGFloat(index) * buttonWidth, CGRectGetMinY(calendarView.frame) - buttonHeight, buttonWidth, buttonHeight)
            weekLabel.text = weeks[index]
            weekLabel.textAlignment = NSTextAlignment.Center
            weekLabel.textColor = UIColor.whiteColor()
            calendarBkgView.addSubview(weekLabel)
        }
        
        let currentComponents = CalendarUtils.getFirstDayComponents(firstDate)
        let firstDayIndex : NSInteger = currentComponents.weekday
        let components = CalendarUtils.getComponents(NSDate())
        let day : NSInteger = firstDayIndex + components.day - 1
        firstDate = NSDate(timeInterval: Double(3600 * 24 * -day), sinceDate: firstDate)
        print(day)
        for index in 0...41 {
            print(index)
            
            firstDate = NSDate(timeInterval: Double(3600 * 24), sinceDate: firstDate)
            let label : CalendarButton = CalendarButton.init(frame:  CGRectMake(offSetX + currentIndex * buttonWidth, currentRow * buttonHeight, buttonWidth, buttonHeight))
            label.backgroundColor = UIColor.lightGrayColor()
            label.setDate(firstDate)
            calendarView.addSubview(label)
            currentIndex++
            if ((index + 1) % 7 == 0) {
                currentRow++
                currentIndex = 0
            }
        }
    }
    
    func loadHolidays() {
        let filePath = NSBundle.mainBundle().pathForResource("holidayTimes", ofType: "plist")
        let dictionary : NSDictionary = NSDictionary(contentsOfFile: filePath!)!
        print(dictionary)
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
        calendarCell.dateLabel.text = dictionary["time"] as? String
        return calendarCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
