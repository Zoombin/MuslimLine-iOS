//
//  PrayTimeViewController.swift
//  Muslim
//
//  Created by 颜超 on 15/11/9.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class PrayTimeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView : UITableView!
    var locationButton : UIButton!
    let prayNames : NSArray = [NSLocalizedString("prayer_names_generic_1", comment: ""), NSLocalizedString("prayer_names_generic_2", comment: ""), NSLocalizedString("prayer_names_generic_3", comment: ""), NSLocalizedString("prayer_names_generic_4", comment: ""), NSLocalizedString("prayer_names_generic_5", comment: ""), NSLocalizedString("prayer_names_generic_6", comment: "")]
    var calendarView : CalendarView!
    var prayTimes : NSMutableArray = NSMutableArray()
    var currentTime : Double = NSDate().timeIntervalSince1970
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("main_pray_label", comment:"")
        initView()
        getPrayTime()
    }
    
    let cellIdentifier = "myCell"
    func initView() {
        let settingLocationView : UIView = UIView(frame: CGRectMake(0, 64, PhoneUtils.screenWidth, 30))
        self.view.addSubview(settingLocationView)
        
        let startX : CGFloat = (PhoneUtils.screenWidth - 100) / 2
        locationButton = UIButton.init(type: UIButtonType.Custom)
        locationButton.frame = CGRectMake(startX, 0, 100, 30)
        locationButton.setImage(UIImage(named: "green_loaction"), forState: UIControlState.Normal)
        locationButton.setTitle(NSLocalizedString("main_location_set", comment: ""), forState: UIControlState.Normal)
        locationButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        locationButton.setTitleColor(Colors.greenColor, forState: UIControlState.Normal)
        locationButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        locationButton.addTarget(self, action: Selector.init("locationSet"), forControlEvents: UIControlEvents.TouchUpInside)
        settingLocationView.addSubview(locationButton)
        
        let calendarBkgView : UIView = UIScrollView(frame: CGRectMake(0, CGRectGetMaxY(settingLocationView.frame), PhoneUtils.screenWidth, 200))
        calendarBkgView.backgroundColor = Colors.searchGray
        self.view.addSubview(calendarBkgView)
        
        tableView = UITableView(frame: CGRectMake(0, CGRectGetMaxY(calendarBkgView.frame), PhoneUtils.screenWidth, PhoneUtils.screenHeight - settingLocationView.frame.size.height - calendarBkgView.frame.size.height - 64), style: UITableViewStyle.Plain)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        //注册ListView的adapter
        tableView!.registerNib(UINib(nibName: "PrayTimeCell", bundle:nil), forCellReuseIdentifier: cellIdentifier)
        
        let nibs : NSArray = NSBundle.mainBundle().loadNibNamed("CalendarView", owner: nil, options: nil)
        calendarView = nibs.lastObject as! CalendarView
        
        let canlendarX : CGFloat = (calendarBkgView.frame.size.width - calendarView.frame.size.width) / 2
        let canlendarY : CGFloat = (calendarBkgView.frame.size.height - calendarView.frame.size.height) / 2
        calendarView.frame = CGRectMake(canlendarX, canlendarY, calendarView.frame.size.width, calendarView.frame.size.height)
        calendarView.backgroundColor = UIColor.clearColor()
        calendarBkgView.addSubview(calendarView)
        
        let leftButton : UIButton = UIButton.init(type: UIButtonType.Custom)
        leftButton.frame = CGRectMake(CGRectGetMinX(calendarView.frame) - 70, calendarView.center.y, 11, 21)
        leftButton.setImage(UIImage(named: "before_small"), forState: UIControlState.Normal)
        leftButton.addTarget(self, action: Selector.init("beforeDayClicked"), forControlEvents: UIControlEvents.TouchUpInside)
        calendarBkgView.addSubview(leftButton)
        
        let rightButton : UIButton = UIButton.init(type: UIButtonType.Custom)
        rightButton.frame = CGRectMake(CGRectGetMaxX(calendarView.frame) + 60, calendarView.center.y, 11, 21)
        rightButton.setImage(UIImage(named: "nextday_small"), forState: UIControlState.Normal)
        rightButton.addTarget(self, action: Selector.init("nextDayClicked"), forControlEvents: UIControlEvents.TouchUpInside)
        calendarBkgView.addSubview(rightButton)
        
        
        let leftSwipeGesture : UISwipeGestureRecognizer = UISwipeGestureRecognizer.init(target: self, action: Selector.init("swipeValueChanged:"))
        leftSwipeGesture.direction = UISwipeGestureRecognizerDirection.Left
        let rightSwipeGesture : UISwipeGestureRecognizer = UISwipeGestureRecognizer.init(target: self, action: Selector.init("swipeValueChanged:"))
        rightSwipeGesture.direction = UISwipeGestureRecognizerDirection.Right
        calendarBkgView.addGestureRecognizer(leftSwipeGesture)
        calendarBkgView.addGestureRecognizer(rightSwipeGesture)
        
        checkIsToday()
    }
    
    func swipeValueChanged(swipeGesture : UISwipeGestureRecognizer) {
        if (swipeGesture.direction == UISwipeGestureRecognizerDirection.Left) {
            currentTime = currentTime + (60 * 60 * 24)
        } else {
            currentTime = currentTime - (60 * 60 * 24)
        }
        checkIsToday()
        getPrayTime()
    }
    
    func beforeDayClicked() {
        currentTime = currentTime - (60 * 60 * 24)
        checkIsToday()
        getPrayTime()
    }
    
    func nextDayClicked() {
        currentTime = currentTime + (60 * 60 * 24)
        checkIsToday()
        getPrayTime()
    }
    
    func checkIsToday() {
        //TODO: 显示下方的日期
        let date : NSDate = NSDate(timeIntervalSince1970: currentTime)
        let dateFormatter1 : NSDateFormatter = NSDateFormatter()
        dateFormatter1.dateFormat = "EEE"
        let dateFormatter2 : NSDateFormatter = NSDateFormatter()
        dateFormatter2.dateFormat = "MMM dd,yyyy"
        let week : String = dateFormatter1.stringFromDate(date)
        let dateString : String = dateFormatter2.stringFromDate(date)
        calendarView.dateLabel.text = dateString
        
        //TODO: 设置日历
        let calendar : NSCalendar = NSCalendar.init(calendarIdentifier: Config.getCalenderType())!
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.calendar = calendar
        let flags = NSCalendarUnit(rawValue: UInt.max)
        let components = calendar.components(flags, fromDate:date)
        calendarView.dayLabel.text = String(format: "%ld", components.day)
        calendarView.muslimDateLabel.text = String(format: "%d/%d", components.month, components.year)
        calendarView.calendarTypeLabel.text = week
        
        let todayTime : NSDate = NSDate()
        let todayStr : NSString = dateFormatter2.stringFromDate(todayTime)
        
        let currentStr : String = dateFormatter2.stringFromDate(NSDate(timeIntervalSince1970: currentTime))
        
        if (todayStr.isEqualToString(currentStr)) {
            calendarView.weekLabel.text = NSLocalizedString("prayer_calendar_today", comment: "")
            return
        }
        calendarView.weekLabel.text = week
    }
    
    func locationSet() {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prayNames.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let prayCell : PrayTimeCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PrayTimeCell
        let prayName : String = prayNames[indexPath.row] as! String
        prayCell.prayNameLabel.text = prayName
        if (indexPath.row == 1) {
            prayCell.praySunImg.hidden = false
        }
        if (prayTimes.count == 6) {
            var prayTime : String = (prayTimes[indexPath.row] as? String)!
            if (prayTime == "-----") {
                prayTime = "00:00"
            }
            prayCell.prayTimeLabel.text = prayTime
        }
        return prayCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    var conNum:Int = 3
    var asrNum:Int = 1
    func getPrayTime()
    {
        let prayTime = PrayTime();
        prayTime.setCalcMethod(Int32(self.conNum))
        prayTime.setAsrMethod(Int32(self.asrNum))
        prayTime.setTimeFormat(Int32(prayTime.Time24))
        prayTime.setHighLatsMethod(Int32(prayTime.AngleBased))
        
        let date = NSDate(timeIntervalSince1970: currentTime)
        let calendar = NSCalendar.currentCalendar()
        
        let flags = NSCalendarUnit(rawValue: UInt.max)
        let components = calendar.components(flags, fromDate:date)
        NSLog("%ld月%ld日%ld时%ld分" ,components.month, components.day, components.hour, components.minute)
        
        let lat : Double = 80.4157074446
        let lng : Double = -29.5312500000

        let times : NSMutableArray = prayTime.getPrayerTimes(components, andLatitude: lat, andLongitude: lng, andtimeZone: 8) as NSMutableArray
        prayTimes.removeAllObjects()
        prayTimes.addObjectsFromArray(times as [AnyObject])
        if (prayTimes.count == 7) {
            //TODO:删除sunset
            prayTimes.removeObjectAtIndex(4)
        }
        tableView.reloadData()
    }

}
