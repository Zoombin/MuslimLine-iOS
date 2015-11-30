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
    let prayNames : NSArray = Config.PrayNameArray
    var calendarView : CalendarView!
    var prayTimes : NSMutableArray = NSMutableArray()
    var currentTime : Double = NSDate().timeIntervalSince1970
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("main_pray_label", comment:"")
        //title右边菜单
        let rightImage : UIImage =  UIImage(named: "top_menu")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: rightImage, style: UIBarButtonItemStyle.Plain, target: self, action: Selector.init("showOrHidePopView"))
        
        initView()
        refreshLocation()
    }
    
    override func viewDidDisappear(animated: Bool) {
        tableView.reloadData()
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkIsToday()
        getPrayTime()
    }
    
    override func refreshUserLocation() {
        //刷新名称
        refreshLocation()
        checkIsToday()
        getPrayTime()
    }
    
    func refreshLocation() {
        let cityName = Config.getCityName().isEmpty ? NSLocalizedString("main_location_set", comment: "") : Config.getCityName()
        locationButton.setTitle(cityName, forState: UIControlState.Normal)
    }
    
    func locationSet() {
        showLocationView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prayTimes.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let prayCell : PrayTimeCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PrayTimeCell
        let status = getPrayMediaStatu(indexPath.row)
        if(0 == status){
            prayCell.voiceButton.setImage(UIImage(named: "voice_off"), forState: UIControlState.Normal)
        }else{
            prayCell.voiceButton.setImage(UIImage(named: "voice_on"), forState: UIControlState.Normal)
        }
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
            prayCell.prayTimeLabel.text = prayTime.uppercaseString
        }
        return prayCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let mdVC = MediaSettingViewController()
        mdVC.AlarmType = indexPath.row
        self.pushViewController(mdVC)
    }
    
    var conNum:Int = 3
    func getPrayTime()
    {
        let prayTime = PrayTime();
        prayTime.setCalcMethod(Int32(self.conNum))
        prayTime.setAsrMethod(Int32(Config.getAsrCalculationjuristicMethod()))
        prayTime.setTimeFormat(Config.getTimeFormat() == 0 ? Int32(prayTime.Time24) : Int32(prayTime.Time12))
        prayTime.setHighLatsMethod(Int32(prayTime.AngleBased))
        
        let date = NSDate(timeIntervalSince1970: currentTime)
        let calendar = NSCalendar.currentCalendar()
        
        let flags = NSCalendarUnit(rawValue: UInt.max)
        let components = calendar.components(flags, fromDate:date)
        NSLog("%ld月%ld日%ld时%ld分" ,components.month, components.day, components.hour, components.minute)
        
        let lat : Double = Config.getLat().doubleValue
        let lng : Double = Config.getLng().doubleValue
        if (lat == 0 && lng == 0) {
            prayTimes.removeAllObjects()
            tableView.reloadData()
            return
        }

        let times : NSMutableArray = prayTime.getPrayerTimes(components, andLatitude: lat, andLongitude: lng, andtimeZone: 8) as NSMutableArray
        prayTimes.removeAllObjects()
        prayTimes.addObjectsFromArray(times as [AnyObject])
        if (prayTimes.count == 7) {
            //TODO:删除sunset
            prayTimes.removeObjectAtIndex(4)
        }
        
        
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "HH:mm"
        let adjustArray : NSMutableArray = NSMutableArray()
        //手动调整
        /*
        for index in 0...prayTimes.count-1 {
            let pray = prayTimes[index]
            let date : NSDate = dateFormat.dateFromString(pray as! String)!
            let adjust = Config.getAdjustPray(index) //获取手动调整时间
            let newDate =  NSDate(timeInterval: Double(( adjust - 60 )*60), sinceDate: date)//保存的是位置，时间要减去60
            let newPray = dateFormat.stringFromDate(newDate)
            Config.savePrayTime(index, time: newPray)//保存最终设置的礼拜时间
            adjustArray.addObject(newPray)
        }

        prayTimes.removeAllObjects()
        prayTimes.addObjectsFromArray(adjustArray as [AnyObject])
        */
        
        tableView.reloadData()
    }
    
    func getPrayMediaStatu(mediaType:Int) ->Int{
        if(Config.FACTION_SHIA == Config.getFaction()){
            //什叶派
            return Config.getShiaAlarm(mediaType)
        }else{
            //逊尼派
            return Config.getSunniAlarm(mediaType)
        }
    }

}
