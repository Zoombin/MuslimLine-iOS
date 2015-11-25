//
//  ViewController.swift
//  Muslim
//
//  Created by 颜超 on 15/10/21.
//  Copyright © 2015年 ZoomBin. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController, AMapLocationManagerDelegate, UISearchBarDelegate, httpClientDelegate, CLLocationManagerDelegate {
    var noticeView : NoticeView!
    var calendarLocationView : CalendarLocationView!
    let topSearchView : UIView = UIView()
    
    var httpClient : MSLHttpClient = MSLHttpClient()
    var manlResultArray : NSMutableArray = NSMutableArray()
    let auto : NSInteger = 0
    let manl : NSInteger = 1
    let city : NSInteger = 2
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var locationSettingsBkgView: UIView!
    
    @IBOutlet weak var autoButton: UIButton!
    @IBOutlet weak var manButton: UIButton!

    @IBOutlet weak var leftLineLabel: UILabel!
    @IBOutlet weak var rightLineLabel: UILabel!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var locationSearchBar: UISearchBar!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //注: 设置title
        title = NSLocalizedString("app_name", comment:"");
        //设置标题栏颜色
        self.navigationController?.navigationBar.barTintColor = Colors.greenColor
        //设置标题的字的颜色
        self.navigationController?.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName) as? [String : AnyObject]
        
        self.view.backgroundColor = Colors.greenColor
        
        //title右边菜单
        let rightImage : UIImage =  UIImage(named: "top_menu")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: rightImage, style: UIBarButtonItemStyle.Plain, target: self, action: Selector.init("showOrHidePopView"))
        
        initTopView()
        initBottomView()

        let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: Selector.init("settingsBkgClicked"))
        locationSettingsBkgView.addGestureRecognizer(tapGesture)
        self.view.bringSubviewToFront(locationSettingsBkgView)
        httpClient.delegate = self
        
        configLocationManager()
        if (Config.getLat() != 0) {
            refresHomeInfo()
        } else {
            getUserLocation()
        }
    }
    
    func succssResult(result: NSObject, tag : NSInteger) {
        self.view.hideToastActivity()
        if (tag == manl) {
//            let manlResult : ManlResult = ManlResult()
//            manlResult.initValues(result as! NSDictionary)
//            if (manlResult.places == nil) {
//                return
//            }
//            if (manlResult.places!.count!.integerValue > 0) {
//               manlResultArray.removeAllObjects()
//               manlResultArray.addObjectsFromArray(manlResult.places?.place as! [AnyObject])
//               manlTableView.reloadData()
//            }
        } else if (tag == auto) {
            let countryInfo : CountryInfo = CountryInfo()
            countryInfo.initValues(result as! NSDictionary)
            Config.saveTimeZone((countryInfo.gmtOffset?.integerValue)!)
            Config.saveCountryCode(countryInfo.countryCode as! String)
            Config.saveLat(countryInfo.lat!)
            Config.saveLng(countryInfo.lng!)
            Log.printLog(countryInfo.gmtOffset!)
            self.httpClient.getCityName((countryInfo.lat?.doubleValue)!, lng: (countryInfo.lng?.doubleValue)!, tag: self.city)
        } else if (tag == city) {
            let query = (result as! NSDictionary)["query"]
            if (query!["count"] as! Int != 0) {
                let results = query!["results"]
                let result = results!["Result"]
                let city = result!["city"]
                Config.saveCityName(city as! String)
                refresHomeInfo()
            } else {
                Log.printLog("定位失败")
                Config.clearHomeValues()
            }
        }
    }
    
    func refresHomeInfo() {
        let cityName = Config.getCityName()
        calendarLocationView.locationButton.setTitle(cityName, forState: UIControlState.Normal)
        CalendarUtils.getDate()
        noticeView.currentTimeLabel.text = CalendarUtils.getDate()
        
        calendarLocationView.yearMonthLabel.text = String(format: "%d/%d", CalendarUtils.currentComponents().month, CalendarUtils.currentComponents().year)
        calendarLocationView.dayLabel.text = String(CalendarUtils.currentComponents().day)
        calendarLocationView.weekLabel.text = CalendarUtils.getWeek()
    }
    
    func errorResult(error : NSError, tag : NSInteger) {
        self.view.hideToastActivity()
        if (tag == manl) {
            
        } else if (tag == auto) {
            
        } else if (tag == city) {
            Log.printLog(error)
            Config.clearHomeValues()
        }
    }
    
    func configLocationManager() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if #available(iOS 8.0, *) {
            self.locationManager.requestAlwaysAuthorization()
        } else {
            // Fallback on earlier versions
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Log.printLog("获取到地址")
        self.locationManager.stopUpdatingLocation()
        self.locationManager.delegate = nil
        let location = locations.last!
        self.httpClient.getTimezoneAndCountryName(location.coordinate.latitude, lng: location.coordinate.longitude, tag: self.auto)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        //获取地址失败
    }
    
    //获取用户位置
    func getUserLocation() {
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    func settingsBkgClicked() {
        locationSettingsBkgView.hidden = !locationSettingsBkgView.hidden
        if (!locationSettingsBkgView.hidden) {
            getUserLocation()
        } else {
            locationSearchBar.resignFirstResponder()
        }
    }
    
    func initTopView() {
//        topSearchView.frame = CGRectMake(0, 64, PhoneUtils.screenWidth, PhoneUtils.screenHeight / 2 - 64)
//        self.view.addSubview(topSearchView)
//        
//        let bkgButton : UIButton = UIButton()
//        bkgButton.frame = CGRectMake(0, 0, topSearchView.frame.size.width, topSearchView.frame.size.height)
//        bkgButton.addTarget(self, action: Selector.init("settingsBkgClicked"), forControlEvents: UIControlEvents.TouchUpInside)
//        bkgButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, topSearchView.frame.size.height / 4, 0)
//        bkgButton.setImage(UIImage(named: "earth"), forState: UIControlState.Normal)
//        topSearchView.addSubview(bkgButton)
//        
//        let settingsButton : UIButton = UIButton()
//        settingsButton.setImage(UIImage(named: "location"), forState: UIControlState.Normal)
//        settingsButton.setTitle(NSLocalizedString("main_location_set", comment: ""), forState: UIControlState.Normal)
//        settingsButton.titleLabel?.font = UIFont.systemFontOfSize(14)
//        settingsButton.backgroundColor = UIColor.clearColor()
//        settingsButton.frame = CGRectMake((topSearchView.frame.size.width - 100) / 2, topSearchView.frame.size.height - topSearchView.frame.size.height / 4, 100, 20)
//        settingsButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
//        topSearchView.addSubview(settingsButton)
//        
//        manButton.addTarget(self, action: Selector.init("leftButtonClicked"), forControlEvents: UIControlEvents.TouchUpInside)
//        autoButton.addTarget(self, action: Selector.init("rightButtonClicked"), forControlEvents: UIControlEvents.TouchUpInside)
//        
//        locationSearchBar.placeholder = NSLocalizedString("dlg_prayer_search_edit_text_hint", comment: "")
//        locationSearchBar.delegate = self
//        
//        manButton.setTitle(NSLocalizedString("dlg_prayer_location_menu_manual", comment: ""), forState: UIControlState.Normal)
//        autoButton.setTitle(NSLocalizedString("dlg_prayer_location_menu_auto", comment: ""), forState: UIControlState.Normal)
        
        let nibs1 = NSBundle.mainBundle().loadNibNamed("NoticeView", owner: nil, options: nil)
        noticeView = nibs1.first as? NoticeView
        let startX = ((PhoneUtils.screenWidth / 2) - noticeView.frame.size.width) / 2
        let startY = 64 + ((PhoneUtils.screenHeight / 2) - 64 - noticeView.frame.size.height) / 2
        Log.printLog(startY)
        noticeView.frame = CGRectMake(startX * 2, startY, noticeView.frame.size.width, noticeView.frame.size.height)
        noticeView.prayTimeButton.addTarget(self, action: Selector.init("clickLiBSJ"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(noticeView!)
        
        let nibs2 = NSBundle.mainBundle().loadNibNamed("CalendarLocationView", owner: nil, options: nil)
        calendarLocationView = nibs2.first as? CalendarLocationView
        calendarLocationView.frame = CGRectMake(startX + (PhoneUtils.screenWidth / 2), startY, calendarLocationView.frame.size.width, calendarLocationView.frame.size.height)
        self.view.addSubview(calendarLocationView!)
        calendarLocationView.locationButton.addTarget(self, action: Selector.init("showLocationView"), forControlEvents: UIControlEvents.TouchUpInside)
        calendarLocationView.calendarButton.addTarget(self, action: Selector.init("clickRiL"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func showLocationView() {
        
    }
    
    func leftButtonClicked() {
        manButton.backgroundColor = UIColor.whiteColor()
        leftLineLabel.backgroundColor = Colors.greenColor
        
        autoButton.backgroundColor = Colors.searchGray
        rightLineLabel.backgroundColor = Colors.searchGray
        
        leftView.hidden = false
        rightView.hidden = true
    }
    
    func rightButtonClicked() {
        manButton.backgroundColor = Colors.searchGray
        leftLineLabel.backgroundColor = Colors.searchGray
        
        autoButton.backgroundColor = UIColor.whiteColor()
        rightLineLabel.backgroundColor = Colors.greenColor
        
        leftView.hidden = true
        rightView.hidden = false
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
            button.layer.borderColor = UIColor.lightGrayColor().CGColor //设置边框的颜色
            button.setImage(UIImage(named: imageNames[index]), forState: UIControlState.Normal)
            button.tag = index + 1
            button.addTarget(self, action: Selector.init(actions[index]), forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(button)
            
            let titleLabel : UILabel = UILabel()
            titleLabel.frame = CGRectMake(0, buttonHeight - (buttonHeight / 4), buttonWidth, 20);
            titleLabel.font = UIFont.boldSystemFontOfSize(14)
            titleLabel.textAlignment = NSTextAlignment.Center
            titleLabel.text = titles[index]
            button.addSubview(titleLabel)
            position++
        }
    }
    
    //古兰经
    func clickGuLj() {
        let guLJViewController = GuLJViewController()
        self.pushViewController(guLJViewController)
    }
    
    //天房方向
    func clickTianFFX() {
        let houseLocationViewController = HouseLocationViewController()
        self.pushViewController(houseLocationViewController)
    }
    
    //礼拜时间
    func clickLiBSJ() {
        let prayTimeViewController : PrayTimeViewController = PrayTimeViewController()
        self.pushViewController(prayTimeViewController)
    }
    
    //附近位置
    func clickFuJWZ() {
        let nearbyViewController : NearbyViewController = NearbyViewController()
        self.pushViewController(nearbyViewController)
    }
    
    //日历
    func clickRiL() {
        let calendarViewController : CalendarViewController = CalendarViewController()
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
    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return manlResultArray.count
//    }
//   
//    //类似android的getView方法，进行生成界面和赋值
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell : UITableViewCell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
//        
//        let info : NSDictionary = manlResultArray[indexPath.row] as! NSDictionary
//        let province : NSString = info["admin1"] as! NSString
//        let city : NSString = info["admin2"] as! NSString
//        let countryInfo : NSDictionary = info["country attrs"] as! NSDictionary
//        let countryCode : NSString = countryInfo["code"] as! NSString
//        
//        let cellTxt : NSString = String(format: "%@ %@ %@", city, province, countryCode)
//        cell.textLabel?.text = String(cellTxt)
//        return cell
//    }
//    
//    //选中
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//    }
//    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//        self.view.makeToastActivity()
//        self.httpClient.searchLocationByName(searchBar.text!, tag: self.manl)
//    }
}

