//
//  ViewController.swift
//  Muslim
//
//  Created by 颜超 on 15/10/21.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController {
    var noticeView : NoticeView!
    var calendarLocationView : CalendarLocationView!
    let topSearchView : UIView = UIView()
    var currentPrayTime : Int = 0
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        PrayTimeUtil.getPrayTime(0) //刷新默认礼拜时间
        if (Config.getLat() != 0) {
            refreshUserLocation()
        }
        topSearchView.hidden = Config.getLat() != 0
        noticeView.hidden = Config.getLat() == 0
        calendarLocationView.hidden = Config.getLat() == 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshUserLocation", name: "ViewBecomeActive", object: nil)
        //注: 设置title
        let titleLabel = UILabel(frame: CGRectMake(0, 0, (240 / 320) * PhoneUtils.screenWidth, 44))
        titleLabel.text = NSLocalizedString("app_name", comment:"")
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.font = UIFont.boldSystemFontOfSize(20)
        titleLabel.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = titleLabel
        
        //设置标题栏颜色
        self.navigationController!.navigationBar.barTintColor = Colors.greenColor
        //设置标题的字的颜色
        self.navigationController!.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName) as? [String : AnyObject]
        
        self.view.backgroundColor = Colors.greenColor
        
        //title右边菜单
        let rightImage : UIImage =  UIImage(named: "top_menu")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: rightImage, style: UIBarButtonItemStyle.Plain, target: self, action: Selector.init("showOrHidePopView"))
        
        initTopView()
        initBottomView()

        let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: Selector.init("settingsBkgClicked"))
        topSearchView.addGestureRecognizer(tapGesture)
    }
    
    override func refreshUserLocation() {
        let cityName = Config.getCityName()
        calendarLocationView.locationNameLabel.text = cityName
        CalendarUtils.getDate()
        noticeView.currentTimeLabel.text = CalendarUtils.getDate()
        currentPrayTime = PrayTimeUtil.getCurrentPrayTime()
        if(currentPrayTime == -1){
            //第一个
            currentPrayTime = 0
        }
        noticeView.prayNameLabel.text = Config.PrayNameArray[currentPrayTime] as? String
        let mediaStatu = PrayTimeUtil.getPrayMediaStatu(currentPrayTime)
        if(0 == mediaStatu){
            noticeView.voiceIconImageView.image =  UIImage(named: "no_voice")
        }else{
            noticeView.voiceIconImageView.image =  UIImage(named: "voice")
        }
        refrashTimeLeft()
        
        calendarLocationView.yearMonthLabel.text = String(format: "%d/%d", CalendarUtils.currentComponents().month, CalendarUtils.currentComponents().year)
        calendarLocationView.dayLabel.text = String(CalendarUtils.currentComponents().day)
        calendarLocationView.weekLabel.text = CalendarUtils.getWeek()
        
        topSearchView.hidden = Config.getLat() != 0
        noticeView.hidden = Config.getLat() == 0
        calendarLocationView.hidden = Config.getLat() == 0
    }
    
    func settingsBkgClicked() {
        showLocationView()
    }
    
    func initTopView() {
        topSearchView.frame = CGRectMake(0, 64, PhoneUtils.screenWidth, PhoneUtils.screenHeight / 2 - 64)
        self.view.addSubview(topSearchView)
        
        let bkgButton : UIButton = UIButton()
        bkgButton.frame = CGRectMake(0, 0, topSearchView.frame.size.width, topSearchView.frame.size.height)
        bkgButton.addTarget(self, action: Selector.init("settingsBkgClicked"), forControlEvents: UIControlEvents.TouchUpInside)
        bkgButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, topSearchView.frame.size.height / 4, 0)
        bkgButton.setImage(UIImage(named: "earth"), forState: UIControlState.Normal)
        topSearchView.addSubview(bkgButton)
        
        let settingsButton : UIButton = UIButton()
        settingsButton.setImage(UIImage(named: "location"), forState: UIControlState.Normal)
        settingsButton.setTitle(NSLocalizedString("main_location_set", comment: ""), forState: UIControlState.Normal)
        settingsButton.addTarget(self, action: Selector.init("settingsBkgClicked"), forControlEvents: UIControlEvents.TouchUpInside)
        settingsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        settingsButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        settingsButton.backgroundColor = UIColor.clearColor()
        settingsButton.frame = CGRectMake((topSearchView.frame.size.width - 100) / 2, topSearchView.frame.size.height - topSearchView.frame.size.height / 4, 100, 20)
        settingsButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        topSearchView.addSubview(settingsButton)
        
        let nibs1Name = UIScreen.mainScreen().bounds.size.width > 400 ? "NoticeViewPlus" : "NoticeView"
        let nibs1 = NSBundle.mainBundle().loadNibNamed(nibs1Name, owner: nil, options: nil)
        noticeView = nibs1.first as? NoticeView
        let startX = ((PhoneUtils.screenWidth / 2) - noticeView.frame.size.width) / 2
        let startY = 64 + ((PhoneUtils.screenHeight / 2) - 64 - noticeView.frame.size.height) / 2
        Log.printLog(startY)
        noticeView.frame = CGRectMake(startX * 2, startY, noticeView.frame.size.width, noticeView.frame.size.height)
        noticeView.prayTimeButton.addTarget(self, action: Selector.init("clickLiBSJ"), forControlEvents: UIControlEvents.TouchUpInside)
        noticeView.prayNameLabel.adjustsFontSizeToFitWidth = true
        self.view.addSubview(noticeView!)
        noticeView.hidden = true
        
        let nibs2Name = UIScreen.mainScreen().bounds.size.width > 400 ? "CalendarLocationViewPlus" : "CalendarLocationView"
        let nibs2 = NSBundle.mainBundle().loadNibNamed(nibs2Name, owner: nil, options: nil)
        calendarLocationView = nibs2.first as? CalendarLocationView
        calendarLocationView.frame = CGRectMake(startX + (PhoneUtils.screenWidth / 2), startY, calendarLocationView.frame.size.width, calendarLocationView.frame.size.height)
        self.view.addSubview(calendarLocationView!)
        calendarLocationView.locationButton.addTarget(self, action: Selector.init("showLocationV"), forControlEvents: UIControlEvents.TouchUpInside)
        calendarLocationView.calendarButton.addTarget(self, action: Selector.init("clickRiL"), forControlEvents: UIControlEvents.TouchUpInside)
        calendarLocationView.hidden = true
    }
    
    func showLocationV() {
        showLocationView()
        Log.printLog("显示设置位置")
    }
        
    func initBottomView() {
        //注: var 和 let的区别， var是变量 let是常量
        //let Object : 类型 比如CGFloat NSInterger等等
        let width : CGFloat = PhoneUtils.screenWidth
        let height : CGFloat = PhoneUtils.screenHeight
        let buttonWidth = width / 3
        let buttonHeight = height / 4;
        //第几行
        var row : CGFloat = 0
        //第几个
        var position : CGFloat = 0
        
        //定义数组 [String] 代表数组里面的String的
        let label1 :String = NSLocalizedString("main_quran_label", comment:"");
        let label2 :String = NSLocalizedString("main_qibla_label", comment:"");
        let label3 :String = NSLocalizedString("main_pray_label", comment:"");
        let label4 :String = NSLocalizedString("main_nearby_label", comment:"");
        let label5 :String = NSLocalizedString("main_holiday_label", comment:"");
        let label6 :String = NSLocalizedString("main_names_label", comment:"");
        let titles : [String] = [label1, label2, label3, label4, label5, label6]
        let actions : [String] = ["clickGuLj", "clickTianFFX", "clickLiBSJ", "clickFuJWZ", "clickRiL", "clickZunZXM"]
        let imageNames : [String] = ["quran", "qibla", "prayer", "nearby", "calenlar", "names"]
        
        for index in 0...5 {
            if (index % 3 == 0 && index != 0) {
                row++
                position = 0
            }
            let button : UIButton = UIButton()
            button.frame = CGRectMake(position * buttonWidth, (height / 2) + (row * buttonHeight), buttonWidth, buttonHeight)
            button.backgroundColor = UIColor.whiteColor()
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.layer.borderWidth = 0.5 //设置边框的宽度
            button.layer.borderColor = UIColor.darkGrayColor().CGColor //设置边框的颜色
            button.setImage(UIImage(named: imageNames[index]), forState: UIControlState.Normal)
            button.tag = index + 1
            button.addTarget(self, action: Selector.init(actions[index]), forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(button)
            
            let titleLabel : UILabel = UILabel()
            titleLabel.frame = CGRectMake(5, buttonHeight - (buttonHeight / 4), buttonWidth - 10 , (buttonHeight / 4));
            titleLabel.font = UIFont.systemFontOfSize(height <= 480 ? 12 : 14)
            titleLabel.numberOfLines = 0
            titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            titleLabel.textAlignment = NSTextAlignment.Center
            titleLabel.text = titles[index]
            button.addSubview(titleLabel)
            position++
        }
    }
    
    var timer :NSTimer?
    var timeLeft : Double = -1
    var nextTotal :Double = -1
    func refrashTimeLeft(){
        timeLeft = PrayTimeUtil.getParyTimeLeft()
        nextTotal = PrayTimeUtil.getNextTimeTotal()
        let pro = timeLeft / nextTotal
        noticeView.currentProgress(pro)
        
        if(timeLeft != -1){
            if(timer != nil){
            }else{
                timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector.init("timerStep"), userInfo: nil, repeats: true)
            }
        }
    }
    
    func timerStep() {
        timeLeft--
        if( timeLeft <= 0 ){
            //重新计算下一个
            refreshUserLocation()
        }else{
            let hour = Int(timeLeft) / 3600
            let min = (Int(timeLeft)-(hour*3600))/60
            let second = Int(timeLeft) - (hour*3600) - (min*60)
            let hTxt : String = hour < 10 ? "0" + String(hour) : String(hour)
            let mTxt : String = min < 10 ? "0" + String(min) : String(min)
            let sTxt : String = second < 10 ? "0" + String(second) : String(second)
            let leftTxt = "-" + hTxt + ":" + mTxt + ":" + sTxt
            noticeView.leftTimeButton.setTitle(leftTxt, forState: UIControlState.Normal)
            
            
            if(second == 0){
                //一分钟再刷新一次
                refreshUserLocation()
            }
        }
    }
    
    //古兰经
    func clickGuLj() {
        let guLJViewController = GuLJViewController(nibName:"GuLJViewController", bundle: nil)
        self.pushViewController(guLJViewController)
    }
    
    //天房方向
    func clickTianFFX() {
        let houseLocationViewController = HouseLocationViewController(nibName:"HouseLocationViewController", bundle: nil)
        self.pushViewController(houseLocationViewController)
    }
    
    //礼拜时间
    func clickLiBSJ() {
        let prayTimeViewController : PrayTimeViewController = PrayTimeViewController(nibName:"PrayTimeViewController", bundle: nil)
        self.pushViewController(prayTimeViewController)
    }
    
    //附近位置
    func clickFuJWZ() {
        let nearbyViewController : NearbyViewController = NearbyViewController(nibName:"NearbyViewController", bundle: nil)
        self.pushViewController(nearbyViewController)
    }
    
    //日历
    func clickRiL() {
        let calendarViewController : CalendarViewController = CalendarViewController(nibName:"CalendarViewController", bundle: nil)
        self.pushViewController(calendarViewController)
    }
    
    //尊主姓名
    func clickZunZXM() {
        let allahNamesViewController : AllahNamesViewController = AllahNamesViewController()
        self.pushViewController(allahNamesViewController)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

