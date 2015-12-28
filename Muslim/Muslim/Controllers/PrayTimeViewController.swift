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
    var currentPrayTime = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("main_pray_label", comment:"")
        //title右边菜单
        let rightImage : UIImage =  UIImage(named: "top_menu")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: rightImage, style: UIBarButtonItemStyle.Plain, target: self, action: Selector.init("showOrHidePopView"))
        
        initView()
        refreshLocation()
        self.view.makeToastActivity()
        shouldShowLocationView()
    }
    
    override func viewDidDisappear(animated: Bool) {
        currentPrayTime = PrayTimeUtil.getCurrentPrayTime()
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
        if(PhoneUtils.rightThemeStyle()){
            locationButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5)
        }
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
        if(PhoneUtils.screenWidth > 400){
            tableView!.registerNib(UINib(nibName: "PrayTimeCell_plus", bundle:nil), forCellReuseIdentifier: cellIdentifier)
        }else{
            tableView!.registerNib(UINib(nibName: "PrayTimeCell", bundle:nil), forCellReuseIdentifier: cellIdentifier)
        }
        
        if(PhoneUtils.screenWidth > 400){
            let nibs : NSArray = NSBundle.mainBundle().loadNibNamed("CalendarView_plus", owner: nil, options: nil)
            calendarView = nibs.lastObject as! CalendarView
        }else{
            let nibs : NSArray = NSBundle.mainBundle().loadNibNamed("CalendarView", owner: nil, options: nil)
            calendarView = nibs.lastObject as! CalendarView
        }
        
        let canlendarX : CGFloat = (calendarBkgView.frame.size.width - calendarView.frame.size.width) / 2
        let canlendarY : CGFloat = (calendarBkgView.frame.size.height - calendarView.frame.size.height) / 2
        calendarView.frame = CGRectMake(canlendarX, canlendarY, calendarView.frame.size.width, calendarView.frame.size.height)
        calendarView.backgroundColor = UIColor.clearColor()
        calendarBkgView.addSubview(calendarView)
        
        let leftButton : UIButton = UIButton.init(type: UIButtonType.Custom)
        leftButton.frame = CGRectMake(CGRectGetMinX(calendarView.frame) - 65, calendarView.center.y-40, 40, 80)
        leftButton.setImage(UIImage(named: "before_small"), forState: UIControlState.Normal)
        leftButton.addTarget(self, action: Selector.init("beforeDayClicked"), forControlEvents: UIControlEvents.TouchUpInside)
        calendarBkgView.addSubview(leftButton)
        
        let rightButton : UIButton = UIButton.init(type: UIButtonType.Custom)
        rightButton.frame = CGRectMake(CGRectGetMaxX(calendarView.frame) + 25, calendarView.center.y-40, 40, 80)
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
        self.view.makeToastActivity()
        checkIsToday()
        prayTimes = PrayTimeUtil.getPrayTime(currentTime)
        currentPrayTime = PrayTimeUtil.getCurrentPrayTime()
        tableView.reloadData()
        self.view.hideToastActivity()
    }
    
    func beforeDayClicked() {
        self.view.makeToastActivity()
        currentTime = currentTime - (60 * 60 * 24)
        checkIsToday()
        prayTimes = PrayTimeUtil.getPrayTime(currentTime)
        currentPrayTime = PrayTimeUtil.getCurrentPrayTime()
        tableView.reloadData()
        self.view.hideToastActivity()
    }
    
    func nextDayClicked() {
        self.view.makeToastActivity()
        currentTime = currentTime + (60 * 60 * 24)
        checkIsToday()
        prayTimes = PrayTimeUtil.getPrayTime(currentTime)
        currentPrayTime = PrayTimeUtil.getCurrentPrayTime()
        tableView.reloadData()
        self.view.hideToastActivity()
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
        prayTimes = PrayTimeUtil.getPrayTime(currentTime)
        currentPrayTime = PrayTimeUtil.getCurrentPrayTime()
        tableView.reloadData()
        self.view.hideToastActivity()
    }
    
    override func refreshUserLocation() {
        //刷新名称
        self.view.makeToastActivity()
        refreshLocation()
        checkIsToday()
        prayTimes = PrayTimeUtil.getPrayTime(currentTime)
        currentPrayTime = PrayTimeUtil.getCurrentPrayTime()
        tableView.reloadData()
        self.view.hideToastActivity()
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
        if(PhoneUtils.screenWidth > 400){
            return 90
        }else{
            return 55
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let prayCell : PrayTimeCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PrayTimeCell
        let status = PrayTimeUtil.getPrayMediaStatu(indexPath.row)
        if(0 == status){
            prayCell.voiceButton.setBackgroundImage(UIImage(named: "voice_off"), forState: UIControlState.Normal)
        }else{
            prayCell.voiceButton.setBackgroundImage(UIImage(named: "voice_on"), forState: UIControlState.Normal)
        }
        let prayName : String = prayNames[indexPath.row] as! String
        prayCell.prayNameLabel.text = prayName
        prayCell.praySunImg.hidden = indexPath.row != 1
        if (prayTimes.count == 6) {
            var prayTime : String = (prayTimes[indexPath.row] as? String)!
            if (prayTime == "-----") {
                prayTime = "00:00"
            }
            prayCell.prayTimeLabel.text = prayTime.uppercaseString
            if(currentPrayTime == indexPath.row){
                prayCell.timeSelectedButton.setImage(UIImage(named: "parytime_selected"), forState: UIControlState.Normal)
            }else{
                prayCell.timeSelectedButton.setImage(UIImage(named: "praytime_no_selected"), forState: UIControlState.Normal)
            }
        }
        return prayCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let mdVC = MediaSettingViewController()
        mdVC.AlarmType = indexPath.row
        self.pushViewController(mdVC)
    }

}
